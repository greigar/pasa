source("helpers.R")

################################################################################
# Region data set
################################################################################
region              <- read_pasa_files("MTPASAREGIONAVAILABILITY")
region.availability <- map_dfr(region, 3) %>% cdt
region.run_times    <- unique(region.availability$PUBLISH_DATETIME)

