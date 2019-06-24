library(tidyverse)
library(lubridate)
library(skimr)
library(vroom) # fast import
library(httr)
library(caret) # knn3 for strategy 1

data_raw_pathname   <- "data/raw/"
data_raw_path       <- function(filename) {str_glue(data_raw_pathname, filename)}
data_processed_path <- function(filename) {str_glue("data/processed/", filename)}

nemweb_root_archive <- "http://www.nemweb.com.au/REPORTS/ARCHIVE/"
nemweb_root_current <- "http://www.nemweb.com.au/REPORTS/CURRENT/"

################################################################################
# Read in raw data files
################################################################################
read_pasa_file <- function(filename) {
  file_data            <- read_lines(filename)
  header_locations     <- str_locate(file_data, "^[CI]")
  header_row_locations <- which(header_locations[,1] == 1)
  headers              <- file_data[header_row_locations]

  n_maxs <- lead(header_row_locations) - header_row_locations
  n_maxs[is.na(n_maxs)] <- 1
  skips  <- header_row_locations - 1

  read_csv_idc <- function(line_type = "header_data") {
    if (line_type == "C") {
      offset         <- 0
      col_names_flag <- FALSE
    } else {
      offset         <- 1
      col_names_flag <- TRUE
    }

    function(ix) {
      read_csv(file_data, skip = skips[ix], n_max = n_maxs[ix] - offset, col_names = col_names_flag)
    }
  }

  detect_line_type <- function(line, ix) {
    x <- str_split(line, ',')[[1]][1]
    list(line_type = x, line_parser = read_csv_idc(x), line_parser_arg = ix)
  }

  runit <- map2(headers, 1:length(headers), detect_line_type)
  data  <- map(runit, function(x) { x$line_parser(x$line_parser_arg) })
}

# datasets are in a list [[1]]
data_set_names <- function(dataset) {
  # assume data set names are in the 3 column
  map(dataset[[1]], function(x) { unique(x[3])}) %>% as_tibble(.name_repair = "unique")
}

gn <- function(dataset, pattern = "*") {
  dataset_names  <- map(dataset[[1]], names) %>% unlist %>% sort
  search_results <- grep(x = dataset_names, pattern = pattern)
  dataset_names[search_results]
}


read_pasa_files <- function(pattern) {
  print(str_glue("loading {pattern}"))
  files <- list.files(data_raw_pathname, full.names = TRUE, pattern = pattern)
  map(files, read_pasa_file)
}

mkdirs <- function() {
  map(c("data", "data/raw", "data/processed", "data/archive"), dir.create, showWarnings = FALSE)
}

# Download files from AEMO site
get_files <- function(root_url, pattern) {

  file_index    <- GET(root_url)
  index_content <- content(file_index, "text")
  file_list     <- str_split(index_content, "<br>")

  filenames <- map(file_list, str_extract, pattern)[[1]] %>%
               na.omit %>%
               str_remove('>')

  download_file <- function(filename) {
    print(paste0("Downloading: ", filename))

    download_from <- paste0(root_url, filename)
    download_to   <- paste0("data/raw/",  filename)

    response <- GET(download_from)
    bin <- content(response, "raw")
    writeBin(bin, download_to)
  }

  map(filenames, download_file)
}

# Read archive zip files, unzip them and move to archive directory
unzip_archive_files <- function(pattern) {
  archive_files <- list.files(data_raw_pathname, full.names = TRUE, pattern = pattern)
  map(archive_files, unzip, exdir = data_raw_pathname)
  map(archive_files, function(x) file.rename(x, str_replace(x, "raw", "archive")))
}

#########################################################
# Clean up date columns - # convert to date time
#########################################################

cdt <- function (data) {
  data %>%
    mutate_at(vars(matches(
      "LATEST_OFFER_DATETIME|LASTCHANGED|SETTLEMENTDATE|INTERVAL_DATETIME|PUBLISH_DATETIME|PERIOD_ENDING|DAY|RUN_DATETIME")),
      ymd_hms)
}

