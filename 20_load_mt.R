source("helpers.R")

################################################################################
# MT PASA
################################################################################
mtpasa <- read_pasa_files("_MTPASA_")

mt.constraint_result      <- map_dfr(mtpasa, 3) %>% cdt
mt.constraint_summary     <- map_dfr(mtpasa, 4) %>% cdt
mt.interconnector_result  <- map_dfr(mtpasa, 5) %>% cdt
mt.lolp_result            <- map_dfr(mtpasa, 6) %>% cdt
mt.region_result          <- map_dfr(mtpasa, 7) %>% cdt
mt.region_summary         <- map_dfr(mtpasa, 8) %>% cdt
mt.region_iteration       <- map_dfr(mtpasa, 9) %>% cdt

