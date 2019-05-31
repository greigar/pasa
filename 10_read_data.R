library(tidyverse)
library(lubridate)
library(skimr)

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

data_set_names <- function(dataset) {
  # assume data set names are in the 3 column
  map(dataset, function(x) { unique(x[3])}) %>% as_tibble(.name_repair = "unique")
}

gn <- function(dataset, pattern = "*") {
  dataset_names  <- map(dataset, names) %>% unlist %>% sort
  search_results <- grep(x = dataset_names, pattern = pattern)
  dataset_names[search_results]
}


read_pasa_files <- function(pattern) {
  print(str_glue("loading {pattern}"))
  files <- list.files("data", full.names = TRUE, pattern = pattern)
  map(files, read_pasa_file)
}


stpasa <- read_pasa_files("_STPASA_")
mtpasa <- read_pasa_files("_MTPASA_")
region <- read_pasa_files("MTPASAREGIONAVAILABILITY")


