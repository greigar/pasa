# Region data set

###################
# Look at NSW1
###################
region.avail_nsw1 <- region.availability %>%
                       filter(regionid == "NSW1") %>%
                       select(publish_datetime, day, regionid, pasaavailability_scheduled)

x_select <- region.avail_nsw1 %>% group_by(day) %>% summarise(publish_datetime = max(publish_datetime))

region.avail_nsw1_merge <- inner_join(region.avail_nsw1, x_select)

ggplot(region.avail_nsw1,
       aes(x      = day,
           y      = pasaavailability_scheduled,
           colour = publish_datetime,
           group  = publish_datetime)) +
       geom_line(alpha = 0.05, show.legend = FALSE) +
       geom_line(data = region.avail_nsw1_merge,
                 aes(x = day,
                     y = pasaavailability_scheduled), colour = "red")

# Demand - old
# region.availability %>%
                # ggplot(aes(x = day, y = demand10)) + geom_line(colour = "red", alpha=0.7) +
                  # geom_line(aes(y = demand50), colour = "blue", alpha = 0.5) +
                  # geom_line(aes(y = pasaavailability_scheduled)) +
                  # facet_wrap(~regionid) +
                  # labs(x = "Date", y = "Demand / PASA Availability")

