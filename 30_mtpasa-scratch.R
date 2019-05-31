# MT PASA

mt.constraint_result      <- mtpasa[[3]]
mt.constraint_summary     <- mtpasa[[4]]
mt.interconnector_result  <- mtpasa[[5]]
mt.lolp_result            <- mtpasa[[6]]
mt.region_result          <- mtpasa[[7]]
mt.region_summary         <- mtpasa[[8]]
mt.region_iteration       <- mtpasa[[9]]

# Convert DAY char to date
mt.constraint_result$DAY          <- ymd_hms(mt.constraint_result$DAY)
mt.constraint_summary$DAY         <- ymd_hms(mt.constraint_summary$DAY)
mt.interconnector_result$DAY      <- ymd_hms(mt.interconnector_result$DAY)
mt.lolp_result$DAY                <- ymd_hms(mt.lolp_result$DAY)
mt.region_result$DAY              <- ymd_hms(mt.region_result$DAY)
mt.region_summary$PERIOD_ENDING   <- ymd_hms(mt.region_summary$PERIOD_ENDING)
mt.region_iteration$PERIOD_ENDING <- ymd_hms(mt.region_iteration$PERIOD_ENDING)

# constraint_result
mt.constraint_result %>% filter(CONSTRAINTID == "N>N-NIL_LSDU") %>%
  ggplot(aes(DAY, PROBABILITYOFBINDING)) + geom_line() + facet_wrap(~PERIODID)

# constraint_summary
mt.constraint_summary %>% filter(CONSTRAINTID == "N>N-NIL_LSDU") %>%
  ggplot(aes(DAY, CONSTRAINTHOURSBINDING)) + geom_line() + facet_wrap(~AGGREGATION_PERIOD)

# interconnector_result
mt.interconnector_result %>% filter(INTERCONNECTORID == "N-Q-MNSP1") %>%
  ggplot(aes(DAY, CALCULATEDEXPORTLIMIT)) + geom_line(colour = "red", alpha = 0.7) +
    geom_line(aes(y = CALCULATEDIMPORTLIMIT), colour = "green") + facet_wrap(~PERIODID)

# lolp_result
mt.lolp_result %>% filter(REGIONID == "NSW1") %>%
  ggplot(aes(DAY, WORST_INTERVAL_DEMAND, colour = LOSSOFLOADPROBABILITY)) + geom_point()

################################################################################
# region_result
################################################################################
ggplot(mt.region_result, aes(DAY, DEMAND)) +
  geom_line() +
  geom_line(aes(y = TOTALSCHEDULEDGEN10), colour = "green",  alpha = 0.4) +
  geom_line(aes(y = TOTALSCHEDULEDGEN50), colour = "orange", alpha = 0.5) +
  geom_line(aes(y = TOTALSCHEDULEDGEN90), colour = "red",    alpha = 0.4) +
  facet_wrap(~REGIONID)

# region_summary
mt.region_summary %>% filter(AGGREGATION_PERIOD == "MONTH") %>%
  ggplot(aes(PERIOD_ENDING, NATIVEDEMAND)) + geom_line() + facet_wrap(~REGIONID)

