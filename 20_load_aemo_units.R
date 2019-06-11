library(tidyverse)
library(xlsx)

if (file.exists("data/processed/aemo_units.csv")) {
  aemo_units <- read_csv("data/processed/aemo_units.csv")
} else {
  aemo_units <- readxl::read_xlsx("data/raw/AEMO Units.xlsx")
  write_csv(x = aemo_units, path = "data/processed/aemo_units.csv")
}

aemo_units %>% filter(REGIONID == "NSW1" & FUEL_TYPE %in% c("Black Coal", "Liquid Fuel", "Brown Coal", "Gas")) %>%
               select(STATION, FUEL_TYPE, CAPACITY) %>%
               unique %>%
               arrange(CAPACITY)

aemo_units %>% filter(FUEL_TYPE %in% c("Black Coal", "Liquid Fuel", "Brown Coal", "Gas")) %>%
               select(REGIONID, STATION, FUEL_TYPE, CAPACITY) %>%
               unique %>%
               arrange(REGIONID, CAPACITY)

