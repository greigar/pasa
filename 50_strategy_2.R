# [1] "I"             "MTPASA"                      "REGIONAVAILABILITY"          "2"                           "PUBLISH_DATETIME"            "DAY"
# [7] "REGIONID"      "PASAAVAILABILITY_SCHEDULED"  "LATEST_OFFER_DATETIME"       "ENERGYUNCONSTRAINEDCAPACITY" "ENERGYCONSTRAINEDCAPACITY"   "NONSCHEDULEDGENERATION"
# [13] "DEMAND10"     "DEMAND50"                    "ENERGYREQDEMAND10"           "ENERGYREQDEMAND50"           "LASTCHANGED"

# ENERGYUNCONSTRAINEDCAPACITY + ENERGYCONSTRAINEDCAPACITY = PASAAVAILABILITY_SCHEDULED
# DEMAND10/50 does not appear to change beteween PUBLISH_DATETIMEs

source("helpers.R")
source("20_load_aemo_units.R")

if (file.exists("data/processed/region.availability_nsw1.csv.gz")) {
  print("reading file region.availability_nsw1.csv.gz")
  region.availability_nsw1 <- read_csv("data/processed/region.availability_nsw1.csv.gz")
} else {
  source("20_load_region.R")
  region.availability_nsw1 <- region.availability %>% filter(REGIONID == "NSW1")
  write_csv(region.availability_nsw1, "data/processed/region.availability_nsw1.csv.gz")
}

region.availability_nsw1 <- region.availability_nsw1 %>% select(-(1:4), -LASTCHANGED, -REGIONID)

# get min max PUBLISH_DATETIME for each day and do a diff between them
pd_min_max <- region.availability_nsw1 %>%
                group_by(DAY) %>%
                summarise(PUBLISH_DATETIME_MIN = min(PUBLISH_DATETIME),
                          PUBLISH_DATETIME_MAX = max(PUBLISH_DATETIME))

# can we do an OR here?
avail_min <- inner_join(pd_min_max, region.availability_nsw1, by = c("DAY" = "DAY", "PUBLISH_DATETIME_MIN" = "PUBLISH_DATETIME")) %>% select(-PUBLISH_DATETIME_MAX)
avail_max <- inner_join(pd_min_max, region.availability_nsw1, by = c("DAY" = "DAY", "PUBLISH_DATETIME_MAX" = "PUBLISH_DATETIME")) %>% select(-PUBLISH_DATETIME_MIN)

# Join Min and Max - to compare
avail_min_pas <- avail_min %>% select(DAY, pas_min = PASAAVAILABILITY_SCHEDULED)
avail_max_pas <- avail_max %>% select(DAY, pas_max = PASAAVAILABILITY_SCHEDULED)

avail_min_max_pas <- inner_join(avail_min_pas, avail_max_pas, by = c("DAY"))
avail_min_max_pas <- avail_min_max_pas %>% mutate(pas_diff = pas_min - pas_max)

avail_min_max_pas %>% ggplot(aes(x = DAY, y = pas_diff)) + geom_line()
avail_min_max_pas %>% filter(abs(pas_diff) > 40 & DAY > ymd(20200101) & DAY < ymd(20200501))


# Plot PASA against DEMAND
avail_max %>% ggplot(aes(x = DAY, y = PASAAVAILABILITY_SCHEDULED)) + geom_line() + geom_line(aes(y = DEMAND50), colour = "blue")

# Plot PASA against CAPACITY

# filter by capacity
f <- function() { avail_min_max_pas %>% filter(pas_diff <= -10 & pas_diff > -110) %>% ggplot(aes(x = DAY, y = pas_diff, colour = pas_diff, group = pas_diff)) + geom_point() }
caps_loss <- aemo_units_nsw1 %>% transmute(capacity_drop = CAPACITY * -1, capacity_drop_loss = CAPACITY * -1 * LOSS_FACTOR) %>% filter(capacity_drop > -100) %>% select(capacity_drop, capacity_drop_loss)
f() + geom_hline(data = caps_loss, aes(yintercept = capacity_drop), colour = "red", alpha = 0.1) + geom_hline(data = caps_loss, aes(yintercept = capacity_drop_loss), colour = "green", alpha = 0.2)


# filter by day
f <- function () { avail_min_max_pas %>% filter(DAY > ymd(20200301) & DAY < ymd(20200402)) %>% ggplot(aes(x = DAY, y = pas_diff)) + geom_point() + facet_wrap(~pas_diff) }
caps_loss <- aemo_units_nsw1 %>% transmute(capacity = CAPACITY, capacity_loss = CAPACITY * LOSS_FACTOR, capacity_drop = capacity * -1, capacity_drop_loss = capacity_loss * -1)
f() + geom_hline(data = caps_loss, aes(yintercept = capacity_drop), colour = "red", alpha = 0.1) + geom_hline(data = caps_loss, aes(yintercept = capacity_drop_loss), colour = "green", alpha = 0.2) + geom_hline(data = caps_loss, aes(yintercept = capacity), colour = "red", alpha = 0.1) + geom_hline(data = caps_loss, aes(yintercept = capacity_loss), colour = "green", alpha = 0.2)




stop("it")

#

# Scratch

region.availability_nsw1_publish_datetimes <- unique(region.availability_nsw1$PUBLISH_DATETIME) %>% sort

rt1 <- region.availability_nsw1_publish_datetimes[1]
rt2 <- region.availability_nsw1_publish_datetimes[2]


# Plot PUBLISH_DATETIMEs
data <- region.availability_nsw1 %>% filter(PUBLISH_DATETIME %in% c(rt1, rt2)) %>% select(PUBLISH_DATETIME, DAY, PASAAVAILABILITY_SCHEDULED)
ggplot(data, aes(x = DAY, y = PASAAVAILABILITY_SCHEDULED, colour = as.factor(PUBLISH_DATETIME) )) + geom_line(alpha = 0.4, show.legend = FALSE)
data <- region.availability_nsw1 %>% select(PUBLISH_DATETIME, DAY, PASAAVAILABILITY_SCHEDULED)
ggplot(data, aes(x = DAY, y = PASAAVAILABILITY_SCHEDULED, colour = as.factor(PUBLISH_DATETIME) )) + geom_line(alpha = 0.4, show.legend = FALSE)

# Compare changes
region_rt1 <- region.availability_nsw1 %>% filter(PUBLISH_DATETIME == rt1) %>% select(DAY, PASAAVAILABILITY_SCHEDULED)
region_rt2 <- region.availability_nsw1 %>% filter(PUBLISH_DATETIME == rt2) %>% select(DAY, PASAAVAILABILITY_SCHEDULED)

data <- region.availability_nsw1 %>% filter(DAY == ymd(20200309)) %>% select(PUBLISH_DATETIME, DAY, PASAAVAILABILITY_SCHEDULED)
data$PASAAVAILABILITY_DIFFERENCE <- data$PASAAVAILABILITY_SCHEDULED - lag(data$PASAAVAILABILITY_SCHEDULED)

