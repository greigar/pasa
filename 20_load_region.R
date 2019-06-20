source("helpers.R")

####################################################################################
# Region data set
#
# region.availability LASTCHANGED looks like it is 22 mins after PUBLISH_DATETIME
####################################################################################
filename      <- data_processed_path("region.availability.csv.gz")
filename_nsw1 <- data_processed_path("region.availability_nsw1.csv.gz")

if (file.exists(filename)) {

  print("Loading region from file")
  region.availability      <- read_csv(filename)
  region.availability_nsw1 <- read_csv(filename_nsw1)

} else {

  print("Loading region from raw zips")

  region                   <- read_pasa_files("MTPASAREGIONAVAILABILITY")
  region.availability      <- map_dfr(region, 3) %>% cdt
  region.availability_nsw1 <- region.availability %>% filter(REGIONID == "NSW1")

  # save results
  write_csv(region.availability,      filename)
  write_csv(region.availability_nsw1, filename_nsw1)

  rm(region)
}

region.publish_datetimes <- unique(region.availability$PUBLISH_DATETIME)

