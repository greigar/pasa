# MT PASA

# constraint_result
mt.constraint_result %>% filter(constraintid == "N>N-NIL_LSDU") %>%
  ggplot(aes(day, probabilityofbinding, group = run_datetime, colour = run_datetime)) + geom_line() + facet_wrap(~periodid)

# constraint_summary
mt.constraint_summary %>% filter(constraintid == "N>N-NIL_LSDU") %>%
  ggplot(aes(day, constrainthoursbinding)) + geom_line() + facet_wrap(~aggregation_period)

# interconnector_result
mt.interconnector_result %>% filter(interconnectorid == "N-Q-MNSP1") %>%
  ggplot(aes(day, calculatedexportlimit)) + geom_line(colour = "red", alpha = 0.7) +
    geom_line(aes(y = calculatedexportlimit), colour = "green") + facet_wrap(~periodid)

# lolp_result
mt.lolp_result %>% filter(regionid == "NSW1") %>%
  ggplot(aes(day, worst_interval_demand, colour = lossofloadprobability)) + geom_point()

################################################################################
# region_result
################################################################################
ggplot(mt.region_result, aes(day, demand)) +
  geom_line() +
  geom_line(aes(y = totalscheduledgen10), colour = "green",  alpha = 0.4) +
  geom_line(aes(y = totalscheduledgen50), colour = "orange", alpha = 0.5) +
  geom_line(aes(y = totalscheduledgen90), colour = "red",    alpha = 0.4) +
  facet_wrap(~regionid)

# region_summary
mt.region_summary %>% filter(aggregation_period == "MONTH") %>%
  ggplot(aes(period_ending, nativedemand)) + geom_line() + facet_wrap(~regionid)

