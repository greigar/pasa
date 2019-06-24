source("helpers.R")

if (all(c("region.availability_nsw1", "aemo_units_nsw1") %in% ls())) {
  print("Using current environment objects")
} else {
  print("Loading from processed files")
  source("20_load_aemo_units.R")
  source("20_load_region.R")
}

# looks like region.availability_nsw1 is sorted by PUBLISH_DATETIME and DAY...but sort anyway
region.availability_nsw1 <- region.availability_nsw1         %>%
                              arrange(DAY, PUBLISH_DATETIME) %>%
                              select(-(1:4), -LASTCHANGED, -REGIONID)

# get min max PUBLISH_DATETIME for each day and do a diff between them
pd_min_max <- region.availability_nsw1 %>%
                group_by(DAY) %>%
                summarise(PUBLISH_DATETIME_MIN = min(PUBLISH_DATETIME),
                          PUBLISH_DATETIME_MAX = max(PUBLISH_DATETIME))

# get the earliest and latest published schedule for each day
avail_min <- semi_join(region.availability_nsw1, pd_min_max,
                       by = c("DAY" = "DAY", "PUBLISH_DATETIME" = "PUBLISH_DATETIME_MIN"))
avail_max <- semi_join(region.availability_nsw1, pd_min_max,
                       by = c("DAY" = "DAY", "PUBLISH_DATETIME" = "PUBLISH_DATETIME_MAX"))

# Join Min and Max - to compare
avail_min_pas <- avail_min %>% select(DAY, pas_min = PASAAVAILABILITY_SCHEDULED)
avail_max_pas <- avail_max %>% select(DAY, pas_max = PASAAVAILABILITY_SCHEDULED)

avail_min_max_pas <- inner_join(avail_min_pas, avail_max_pas, by = c("DAY")) %>%
                       mutate(pas_diff = pas_min - pas_max)

# combinations of station and unit - assume stations' units are all the same CAPACITY
# aemo_stations_nsw1 <- aemo_units_nsw1 %>% select(STATION, CAPACITY) %>% unique
# z <- c(700, 700, 700, 700)
# map(1:4, function(x) combn(z, x) %>% colSums) %>% unlist %>% unique
aemo_stations_nsw1 <- aemo_units_nsw1 %>% select(STATION, DUID, CAPACITY) %>%
                                          group_by(STATION) %>%
                                          mutate(cs = cumsum(CAPACITY)) %>%
                                          ungroup %>%
                                          select(DUID, CAPACITY = cs)

# Do a rough knn on the data to see which STATIONS lie closest
candidates  <- tibble(CAPACITY = abs(avail_min_max_pas$pas_diff))
fit_knn3    <- knn3(DUID ~ CAPACITY, data = aemo_stations_nsw1, k = 1)
predictions <- predict(fit_knn3, candidates)
results     <- as_tibble(cbind(avail_min_max_pas, predictions))

results_by_station <- results %>% gather(key = "DUID", value = "probability", 5:53) %>% filter(probability != 0)

results_by_station <- inner_join(results_by_station, aemo_stations_nsw1, by = "DUID") %>%
                        mutate(diff = abs(CAPACITY - abs(pas_diff))) %>%
                        arrange(diff)

