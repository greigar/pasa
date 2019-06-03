library(tidyverse)
library(lubridate)

# write_csv(st.avail_nsw1_merge, "data/processed/st.avail_nsw1_merge.csv")
# write_csv(region.avail_nsw1_merge, "data/processed/region.avail_nsw1_merge.csv")

st.avail_nsw1_merge     <- read_csv("data/processed/st.avail_nsw1_merge.csv")
region.avail_nsw1_merge <- read_csv("data/processed/region.avail_nsw1_merge.csv")

st_region <- inner_join(st.avail_nsw1_merge, region.avail_nsw1_merge, by = c("interval_datetime" = "day"))
st_region <- st_region %>% select(interval_datetime, apa = aggregatepasaavailability, pas = pasaavailability_scheduled)

ggplot(st_region,
       aes(x = interval_datetime, y = apa, colour = "Agg PASA Avail")) + geom_line() +
       geom_line(aes(y = pas, colour = "PASA Sched")) +
       theme(legend.position = "top", plot.title = element_text(hjust = 0.5, face = "bold")) +
       theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
       labs(x = "Date", y = "MW") +
       guides(alpha = FALSE, color = guide_legend(title = "Data Set"))


cor(st_region$apa, st_region$pas)
plot(st_region$apa, st_region$pas)

#################################
# Fine grained version
#################################
st.avail_nsw1_merge$idd     <- date(st.avail_nsw1_merge$interval_datetime)
region.avail_nsw1_merge$ddd <- date(region.avail_nsw1_merge$day)

st_region <- inner_join(st.avail_nsw1_merge, region.avail_nsw1_merge, by = c("idd" = "ddd"))
st_region <- st_region %>% select(interval_datetime, apa = aggregatepasaavailability, pas = pasaavailability_scheduled)

ggplot(st_region,
       aes(x = interval_datetime, y = apa, colour = "Agg PASA Avail")) + geom_line() +
       geom_line(aes(y = pas, colour = "PASA Sched")) +
       theme(legend.position = "top", plot.title = element_text(hjust = 0.5, face = "bold")) +
       labs(x = "Date", y = "MW") +
       guides(alpha = FALSE, color = guide_legend(title = "Data Set"))

########################################
# TO DO - All Regions
########################################

st_region_all <- inner_join(st.avail_merge, region.avail_merge, by = c("interval_datetime" = "day", "regionid"))
st_region_all <- st_region_all %>% select(regionid, interval_datetime, apa = aggregatepasaavailability, pas = pasaavailability_scheduled)

ggplot(st_region_all,
       aes(x = interval_datetime, y = apa, colour = "Agg PASA Avail")) + geom_line() +
       geom_line(aes(y = pas, colour = "PASA Sched")) +
       theme(legend.position = "top", plot.title = element_text(hjust = 0.5, face = "bold")) +
       theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
       facet_wrap(~regionid)

st.avail_merge$idd     <- date(st.avail_merge$interval_datetime)
region.avail_merge$ddd <- date(region.avail_merge$day)

st_region <- inner_join(st.avail_merge, region.avail_merge, by = c("idd" = "ddd", "regionid"))
st_region <- st_region %>% select(interval_datetime, apa = aggregatepasaavailability, pas = pasaavailability_scheduled, regionid)

ggplot(st_region,
       aes(x = interval_datetime, y = apa, colour = "Agg PASA Avail")) + geom_line() +
       geom_line(aes(y = pas, colour = "PASA Sched")) +
       theme(legend.position = "top", plot.title = element_text(hjust = 0.5, face = "bold")) +
       theme() +
       facet_wrap(~regionid)



