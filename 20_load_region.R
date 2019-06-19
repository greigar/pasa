source("helpers.R")

####################################################################################
# Region data set
#
# region.availability LASTCHANGED looks like it is 22 mins after PUBLISH_DATETIME
####################################################################################
region                   <- read_pasa_files("MTPASAREGIONAVAILABILITY")
region.availability      <- map_dfr(region, 3) %>% cdt
region.publish_datetimes <- unique(region.availability$PUBLISH_DATETIME)

# Create dataset for NSW
region.availability_nsw1 <- region.availability %>% filter(REGIONID == "NSW1")
write_csv(region.availability_nsw1, "data/processed/region.availability_nsw1.csv.gz")

rm(region)
