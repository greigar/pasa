# [1] "I"             "MTPASA"                      "REGIONAVAILABILITY"          "2"                           "PUBLISH_DATETIME"            "DAY"
# [7] "REGIONID"      "PASAAVAILABILITY_SCHEDULED"  "LATEST_OFFER_DATETIME"       "ENERGYUNCONSTRAINEDCAPACITY" "ENERGYCONSTRAINEDCAPACITY"   "NONSCHEDULEDGENERATION"
# [13] "DEMAND10"     "DEMAND50"                    "ENERGYREQDEMAND10"           "ENERGYREQDEMAND50"           "LASTCHANGED"

# ENERGYUNCONSTRAINEDCAPACITY + ENERGYCONSTRAINEDCAPACITY = PASAAVAILABILITY_SCHEDULED
# DEMAND10/50 does not appear to change beteween PUBLISH_DATETIMEs

library(caret) # knn3

source("helpers.R")
source("20_load_aemo_units.R")

if (file.exists("data/processed/region.availability_nsw1.csv.gz")) {
  region.availability_nsw1 <- read_csv("data/processed/region.availability_nsw1.csv.gz")
} else {
  source("20_load_region.R")
}

region.availability_nsw1 <- region.availability_nsw1 %>% select(-(1:4), -LASTCHANGED, -REGIONID)

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

avail_min_max_pas %>% ggplot(aes(x = DAY, y = pas_diff)) + geom_line()
avail_min_max_pas %>% filter(abs(pas_diff) > 40 & DAY > ymd(20200101) & DAY < ymd(20200501))

#
# Do a rough knn on the data to see which stations lies closest
#

aemo_stations_nsw1 <- aemo_units_nsw1 %>% select(STATION, CAPACITY) %>% unique

candidates  <- tibble(CAPACITY = abs(avail_min_max_pas$pas_diff))
fit_knn3    <- knn3(STATION ~ CAPACITY, data = aemo_stations_nsw1, k = 1)
predictions <- predict(fit_knn3, candidates)
results     <- as_tibble(cbind(avail_min_max_pas, predictions))

results_by_station <- results %>% gather(key = "STATION", value = "probability", 5:36) %>% filter(probability != 0)

results_by_station <- inner_join(results_by_station, aemo_units_nsw1, by = "STATION") %>%
                        mutate(diff = abs(CAPACITY - abs(pas_diff))) %>%
                        arrange(diff)


results_by_station %>% ggplot(aes(x = DAY, y = pas_diff)) + geom_line() + geom_point(aes(y = pas_diff, colour = STATION))
results_by_station %>% filter(CAPACITY > 10 & diff > 100) %>% ggplot(aes(x = DAY, y = diff, colour = STATION)) + geom_point()

stop("it")

########################################
# Plot PASA against DEMAND
########################################
avail_max %>% ggplot(aes(x = DAY, y = PASAAVAILABILITY_SCHEDULED)) + geom_line() + geom_line(aes(y = DEMAND50), colour = "blue")


########################################
# Plot PASA against CAPACITY
########################################

# filter by capacity
f <- function() { avail_min_max_pas %>% filter(pas_diff <= -10 & pas_diff > -110) %>% ggplot(aes(x = DAY, y = pas_diff, colour = pas_diff, group = pas_diff)) + geom_point() }
caps_loss <- aemo_units_nsw1 %>% transmute(capacity_drop = CAPACITY * -1, capacity_drop_loss = CAPACITY * -1 * LOSS_FACTOR) %>% filter(capacity_drop > -100) %>% select(capacity_drop, capacity_drop_loss)
f() + geom_hline(data = caps_loss, aes(yintercept = capacity_drop), colour = "red", alpha = 0.1) + geom_hline(data = caps_loss, aes(yintercept = capacity_drop_loss), colour = "green", alpha = 0.2)


# filter by day
caps_loss <- aemo_units_nsw1 %>%
               transmute(capacity           = CAPACITY,
                         capacity_loss      = CAPACITY      * LOSS_FACTOR,
                         capacity_drop      = capacity      * -1,
                         capacity_drop_loss = capacity_loss * -1)

plot_avail <- function(date_from, date_to) {

  avail_data           <- avail_min_max_pas %>% filter(DAY >= ymd(date_from) & DAY < ymd(date_to) & abs(pas_diff) >= 47)
  mw_range             <- range(abs(avail_data$pas_diff))
  caps_loss_candidates <- caps_loss %>% filter(capacity >= mw_range[1] - 50 & capacity <= mw_range[2] + 50)

    ggplot(avail_data, aes(x = DAY, y = pas_diff)) + geom_point() + facet_wrap(~pas_diff) +
      geom_hline(data = caps_loss_candidates, aes(yintercept = capacity_drop),      colour = "red",   alpha = 0.1) +
      geom_hline(data = caps_loss_candidates, aes(yintercept = capacity_drop_loss), colour = "green", alpha = 0.2) +
      geom_hline(data = caps_loss_candidates, aes(yintercept = capacity),           colour = "red",   alpha = 0.1) +
      geom_hline(data = caps_loss_candidates, aes(yintercept = capacity_loss),      colour = "green", alpha = 0.2)
}

plot_avail(20200301, 20200402)

########################################
# Plot PUBLISH_DATETIMEs
########################################
region.availability_nsw1_publish_datetimes <- unique(region.availability_nsw1$PUBLISH_DATETIME) %>% sort

rt1 <- region.availability_nsw1_publish_datetimes[1]
rt2 <- region.availability_nsw1_publish_datetimes[2]

data <- region.availability_nsw1 %>% filter(PUBLISH_DATETIME %in% c(rt1, rt2)) %>% select(PUBLISH_DATETIME, DAY, PASAAVAILABILITY_SCHEDULED)
ggplot(data, aes(x = DAY, y = PASAAVAILABILITY_SCHEDULED, colour = as.factor(PUBLISH_DATETIME) )) + geom_line(alpha = 0.4, show.legend = FALSE)

data <- region.availability_nsw1 %>% select(PUBLISH_DATETIME, DAY, PASAAVAILABILITY_SCHEDULED)
ggplot(data, aes(x = DAY, y = PASAAVAILABILITY_SCHEDULED, colour = as.factor(PUBLISH_DATETIME) )) + geom_line(alpha = 0.4, show.legend = FALSE)

# Compare changes
region_rt1 <- region.availability_nsw1 %>% filter(PUBLISH_DATETIME == rt1) %>% select(DAY, PASAAVAILABILITY_SCHEDULED)
region_rt2 <- region.availability_nsw1 %>% filter(PUBLISH_DATETIME == rt2) %>% select(DAY, PASAAVAILABILITY_SCHEDULED)

data <- region.availability_nsw1 %>% filter(DAY == ymd(20200309)) %>% select(PUBLISH_DATETIME, DAY, PASAAVAILABILITY_SCHEDULED)
data$PASAAVAILABILITY_DIFFERENCE <- data$PASAAVAILABILITY_SCHEDULED - lag(data$PASAAVAILABILITY_SCHEDULED)

