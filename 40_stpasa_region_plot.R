library(tidyverse)
library(lubridate)

# write_csv(st.avail_nsw1_merge, "data/st.avail_nsw1_merge.csv")
# write_csv(region.avail_nsw1_merge, "data/region.avail_nsw1_merge.csv")

st.avail_nsw1_merge     <- read_csv("data/st.avail_nsw1_merge.csv")
region.avail_nsw1_merge <- read_csv("data/region.avail_nsw1_merge.csv")

st_region <- inner_join(st.avail_nsw1_merge, region.avail_nsw1_merge, by = c("interval_datetime" = "day"))

st_region <- st_region %>% select(interval_datetime, apa = aggregatepasaavailability, pas = pasaavailability_scheduled)

ggplot(st_region,
       aes(x = interval_datetime, y = apa, colour = "Agg PASA Avail")) + geom_line() +
       geom_line(aes(y = pas, colour = "PASA Sched")) +
       theme(legend.position = "top", plot.title = element_text(hjust = 0.5, face = "bold")) +
       theme(axis.text.x = element_text(angle = 30, hjust = 1))


cor(st_region$apa, st_region$pas)
plot(st_region$apa, st_region$pas)


st.avail_nsw1_merge$idd <- date(st.avail_nsw1_merge$interval_datetime)
region.avail_nsw1_merge$ddd <- date(region.avail_nsw1_merge$day)
st_region <- inner_join(st.avail_nsw1_merge, region.avail_nsw1_merge, by = c("idd" = "ddd"))
st_region <- st_region %>% select(interval_datetime, apa = aggregatepasaavailability, pas = pasaavailability_scheduled)
ggplot(st_region,
       aes(x = interval_datetime, y = apa, colour = "Agg PASA Avail")) + geom_line() +
       geom_line(aes(y = pas, colour = "PASA Sched")) +
       theme(legend.position = "top", plot.title = element_text(hjust = 0.5, face = "bold")) +
       theme()
