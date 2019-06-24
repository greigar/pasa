source("helpers.R")

mkdirs()

# STPASA
root_url <- str_glue(nemweb_root_current, "Short_Term_PASA_Reports/")
pattern  <- ">PUBLIC_STPASA.*2019....0000.*zip"
get_files(root_url, pattern)

# Regional
pattern      <- ">PUBLIC_MTPASAREGIONAVAILABILITY_.*zip"
pattern_zips <- "PUBLIC_MTPASAREGIONAVAILABILITY_201......zip"

root_url <- str_glue(nemweb_root_current, "MTPASA_RegionAvailability/")
get_files(root_url, pattern)

root_url <- str_glue(nemweb_root_archive, "MTPASA_RegionAvailability/")
get_files(root_url, pattern)
unzip_archive_files(pattern_zips)

# TRADING
# Next_Day_Trading/

