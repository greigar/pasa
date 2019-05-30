# MT PASA

constraint_result      <- mtpasa[[3]]
constraint_summary     <- mtpasa[[4]]
interconnector_result  <- mtpasa[[5]]
lolp_result            <- mtpasa[[6]]
region_result          <- mtpasa[[7]]
region_summary         <- mtpasa[[8]]
region_iteration       <- mtpasa[[9]]

# Convert DAY char to date
constraint_result$DAY          <- ymd_hms(constraint_result$DAY)
constraint_summary$DAY         <- ymd_hms(constraint_summary$DAY)
interconnector_result$DAY      <- ymd_hms(interconnector_result$DAY)
lolp_result$DAY                <- ymd_hms(lolp_result$DAY)
region_result$DAY              <- ymd_hms(region_result$DAY)
region_summary$PERIOD_ENDING   <- ymd_hms(region_summary$PERIOD_ENDING)
region_iteration$PERIOD_ENDING <- ymd_hms(region_iteration$PERIOD_ENDING)

# constraint_result
x <- constraint_result %>% filter(CONSTRAINTID == "N>N-NIL_LSDU")
ggplot(x, aes(DAY, PROBABILITYOFBINDING)) + geom_line() + facet_wrap(~PERIODID)

# constraint_summary
x <- constraint_summary %>% filter(CONSTRAINTID == "N>N-NIL_LSDU")
ggplot(x, aes(DAY, CONSTRAINTHOURSBINDING)) + geom_line() + facet_wrap(~AGGREGATION_PERIOD)

# interconnector_result
x <- interconnector_result %>% filter(INTERCONNECTORID == "N-Q-MNSP1")
ggplot(x, aes(DAY, CALCULATEDEXPORTLIMIT)) + geom_line(colour = "red", alpha = 0.7) +
  geom_line(aes(y = CALCULATEDIMPORTLIMIT), colour = "green") + facet_wrap(~PERIODID)

# lolp_result
x <- lolp_result %>% filter(REGIONID == "NSW1")
ggplot(x, aes(DAY, WORST_INTERVAL_DEMAND, colour = LOSSOFLOADPROBABILITY)) + geom_point()

################################################################################
# region_result
################################################################################
ggplot(region_result, aes(DAY, DEMAND)) +
  geom_line() +
  geom_line(aes(y = TOTALSCHEDULEDGEN10), colour = "green",  alpha = 0.4) +
  geom_line(aes(y = TOTALSCHEDULEDGEN50), colour = "orange", alpha = 0.5) +
  geom_line(aes(y = TOTALSCHEDULEDGEN90), colour = "red",    alpha = 0.4) +
  facet_wrap(~REGIONID)

# region_summary
region_summary %>% filter(AGGREGATION_PERIOD == "MONTH") %>% ggplot(aes(PERIOD_ENDING, NATIVEDEMAND)) + geom_line() + facet_wrap(~REGIONID)
