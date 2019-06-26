source("helpers.R")
source("20_load_aemo_units.R")
source("20_load_region.R")

# looks like region.availability_nsw1 is sorted by PUBLISH_DATETIME and DAY...but sort anyway
region.availability_nsw1 <- region.availability_nsw1 %>% arrange(DAY, PUBLISH_DATETIME)

region.availability_nsw1$pas_diffs <-      region.availability_nsw1$PASAAVAILABILITY_SCHEDULED -
                                       lag(region.availability_nsw1$PASAAVAILABILITY_SCHEDULED )

region.availability_nsw1 %>% filter(DAY == ymd("2019-06-24") & pas_diffs != 0)

candidates  <- tibble(CAPACITY = abs(region.availability_nsw1$pas_diffs))

avail_rolling_pas <- region.availability_nsw1 %>% filter(pas_diffs != 0)
candidates        <- tibble(CAPACITY = abs(avail_rolling_pas$pas_diffs))
fit_knn3          <- knn3(DUID ~ CAPACITY, data = aemo_stations_nsw1, k = 1)
predictions       <- predict(fit_knn3, candidates)
results           <- as_tibble(cbind(avail_rolling_pas, predictions))

results_by_station <- results %>% gather(key = "DUID", value = "probability", 19:67) %>% filter(probability != 0)


results_by_station <- inner_join(results_by_station, aemo_stations_nsw1, by = "DUID") %>%
                        mutate(diff = abs(CAPACITY - abs(pas_diffs))) %>%
                        arrange(diff)

results_by_station %>% filter(DAY > ymd(20190101) & DAY < ymd(20190301) & abs(pas_diffs) > 100) %>%
  ggplot(aes(x = DAY, y = pas_diffs)) + geom_point(shape = 3) +
    geom_point(aes(y = CAPACITY * sign(pas_diffs), colour = DUID, size = diff/CAPACITY), alpha = 0.5)

ggsave("images/strategy_2-rolling.png")


# try with loss (not much difference???)
#   aemo_stations_nsw1 <- aemo_units_nsw1 %>% select(STATION, DUID, CAPACITY_WITH_LOSS) %>%
#                                           group_by(STATION) %>%
#                                           mutate(cs = cumsum(CAPACITY_WITH_LOSS)) %>%
#                                           ungroup %>%
#                                           select(DUID, CAPACITY = cs)
#
