# Region data set

# get a list of all the column names
map(region, names) %>% unlist %>% sort

region_availability <- region[[3]]

# Convert date char to date
region_availability$DAY <- ymd_hms(region_availability$DAY)

# region_solution
region_availability %>%
                ggplot(aes(x = DAY, y = DEMAND10)) + geom_line(colour = "red", alpha=0.7) +
                  geom_line(aes(y = DEMAND50), colour = "blue", alpha = 0.5) +
                  geom_line(aes(y = PASAAVAILABILITY_SCHEDULED)) +
                  facet_wrap(~REGIONID) +
                  labs(x = "Date", y = "Demand / PASA Availability")

