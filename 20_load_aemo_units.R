source("helpers.R")

if (file.exists("data/processed/aemo_units.csv")) {
  aemo_units <- read_csv("data/processed/aemo_units.csv")
} else {
  library(xlsx)
  aemo_units <- readxl::read_xlsx("data/raw/AEMO Units.xlsx")
  write_csv(x = aemo_units, path = "data/processed/aemo_units.csv")
}

#
# Assume effective from/to has not changed
#
aemo_units_nsw1 <- aemo_units %>%
                     filter(REGIONID == "NSW1") %>% #  & FUEL_TYPE %in% c("Black Coal", "Liquid Fuel", "Brown Coal", "Gas")) %>%
                     select(DUID, STATION, FUEL_TYPE, CAPACITY, LOSS_FACTOR) %>%
                     mutate(CAPACITY_WITH_LOSS = CAPACITY * LOSS_FACTOR)

aemo_units_nsw1  %>% group_by(DUID, STATION, FUEL_TYPE) %>% summarise(tot_cap = sum(CAPACITY), tot_cap_loss = sum(CAPACITY_WITH_LOSS)) %>% arrange(tot_cap) %>% as.data.frame


aemo_units %>% filter(FUEL_TYPE %in% c("Black Coal", "Liquid Fuel", "Brown Coal", "Gas")) %>%
               select(REGIONID, DUID, STATION, FUEL_TYPE, CAPACITY) %>%
               unique %>%
               arrange(REGIONID, DUID, CAPACITY)

# combinations of station and unit - assume stations' units are all the same CAPACITY
# aemo_stations_nsw1 <- aemo_units_nsw1 %>% select(STATION, CAPACITY) %>% unique
# z <- c(700, 700, 700, 700) ; map(1:4, function(x) combn(z, x) %>% colSums) %>% unlist %>% unique
aemo_stations_nsw1 <- aemo_units_nsw1 %>% select(STATION, DUID, CAPACITY) %>%
                                          group_by(STATION) %>%
                                          mutate(cs = cumsum(CAPACITY)) %>%
                                          ungroup %>%
                                          select(DUID, CAPACITY = cs)


