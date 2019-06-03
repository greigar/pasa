# ST PASA

##############################################################################
# region_solutions - look at AGGREGATEPASAAVAILABILITY
##############################################################################

st.avail_nsw1 <- st.region_solutions %>%
                       filter(regionid == "NSW1" & runtype == "OUTAGE_LRC") %>%
                       select(run_datetime, interval_datetime, regionid, aggregatepasaavailability)

x_select <- st.avail_nsw1 %>% group_by(interval_datetime) %>% summarise(run_datetime = max(run_datetime))

st.avail_nsw1_merge <- inner_join(st.avail_nsw1, x_select)

ggplot(st.avail_nsw1_merge,
       aes(x = interval_datetime,
           y = aggregatepasaavailability)) +
       geom_line(colour = "red") +
       geom_line(data = st.avail_nsw1,
                 aes(x = interval_datetime,
                     y = aggregatepasaavailability,
                     colour = run_datetime,
                     group = run_datetime),
                 alpha = 0.15,
                 show.legend = FALSE)


##############################################################################
# Differences between run times
##############################################################################

x1 <- st.region_solutions %>% filter(runtype == "OUTAGE_LRC" & run_datetime == st.run_times[1]) %>%
        select(run_datetime, interval_datetime, regionid, aggregatepasaavailability)
x2 <- st.region_solutions %>% filter(runtype == "OUTAGE_LRC" & run_datetime == st.run_times[2]) %>%
        select(run_datetime2 = run_datetime, interval_datetime, regionid, aggregatepasaavailability2 = aggregatepasaavailability)

x12 <- inner_join(x1, x2, by = c("interval_datetime", "regionid"))
x12$agg_diff <- x12$aggregatepasaavailability - x12$aggregatepasaavailability2

x12 %>% filter(regionid == "NSW1") %>%
        ggplot(aes(x = interval_datetime, y = aggregatepasaavailability)) + geom_line() +
        geom_line(aes(y = aggregatepasaavailability),  colour = "red") +
        geom_line(aes(y = aggregatepasaavailability2), colour = "blue") +
        facet_wrap(~regionid)

xgather <- x12 %>% select(-run_datetime, -run_datetime2, -agg_diff) %>%
                   gather(key = "rt", value = "apa", c(-interval_datetime, -regionid))
ggplot(xgather, aes(x = interval_datetime, y = apa, colour = rt)) + geom_line() + facet_wrap(~regionid)

#######################################
# TODO
#######################################

st.avail <- st.region_solutions %>%
              filter(runtype == "OUTAGE_LRC") %>%
              select(run_datetime, interval_datetime, regionid, aggregatepasaavailability)

max_select <- st.avail %>% group_by(regionid, interval_datetime) %>% summarise(run_datetime = max(run_datetime))

st.avail_merge <- inner_join(st.avail, max_select)

ggplot(st.avail_merge,
       aes(x = interval_datetime,
           y = aggregatepasaavailability)) +
       geom_line(colour = "red") +
       geom_line(data = st.avail,
                 aes(x = interval_datetime,
                     y = aggregatepasaavailability,
                     colour = run_datetime,
                     group = run_datetime),
                 alpha = 0.15,
                 show.legend = FALSE) +
facet_wrap(~regionid)



