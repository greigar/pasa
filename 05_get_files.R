library(tidyverse)
library(httr)

# STPASA
root_url <- "http://www.nemweb.com.au/REPORTS/CURRENT/Short_Term_PASA_Reports/"
pattern  <- ">PUBLIC_STPASA.*2019....0000.*zip"

# Regional
root_url <- "http://www.nemweb.com.au/REPORTS/CURRENT/MTPASA_RegionAvailability/"
pattern  <- ">PUBLIC_MTPASAREGIONAVAILABILITY_.*zip"

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


