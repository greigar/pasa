# ST PASA

region_solution         <- stpasa[[3]]
interconnector_solution <- stpasa[[4]]
constraint_solution     <- stpasa[[5]]

# Convert date char to date
region_solution$INTERVAL_DATETIME          <- ymd_hms(region_solution$INTERVAL_DATETIME)
interconnector_solution$INTERVAL_DATETIME  <- ymd_hms(interconnector_solution$INTERVAL_DATETIME)
constraint_solution$INTERVAL_DATETIME      <- ymd_hms(constraint_solution$INTERVAL_DATETIME)

# region_solution
region_solution %>% filter(RUNTYPE == "OUTAGE_LRC") %>%
                ggplot(aes(x = INTERVAL_DATETIME, y = DEMAND10)) + geom_line(colour = "green", alpha=0.7)  +
                  geom_line(aes(y = DEMAND50), colour = "orange", alpha = 0.7) +
                  geom_line(aes(y = DEMAND90), colour = "red", alpha = 0.7) +
                  geom_line(aes(y = AGGREGATEPASAAVAILABILITY), colour = "black", alpha = 1) +
                  facet_wrap(~REGIONID)

# interconnector_solution
interconnector_solution %>%
  ggplot(aes(INTERVAL_DATETIME, CALCULATEDEXPORTLIMIT)) + geom_line(colour = "red") +
    geom_line(aes(y = CALCULATEDIMPORTLIMIT), colour = "green", alpha = 0.5) +
    facet_wrap(~INTERCONNECTORID)

# constraint_solution
constraint_solution %>%
  ggplot(aes(INTERVAL_DATETIME, CAPACITYRHS)) + geom_line() +
    facet_wrap(~CONSTRAINTID)
