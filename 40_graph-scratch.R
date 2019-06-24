
region[[3]] %>% transmute(
                          day      = ymd_hms(DAY),
                          region   = REGIONID,
                          demand10 = DEMAND10,
                          demand50 = DEMAND50,
                          pasa_availability    = PASAAVAILABILITY_SCHEDULED,
                          constrained_energy   = ENERGYCONSTRAINEDCAPACITY,
                          unconstrained_energy = ENERGYUNCONSTRAINEDCAPACITY
                          ) %>%
                ggplot(aes(x = day, y = demand10)) +
                  geom_line(colour = "red", alpha=0.7) +
                  geom_line(aes(y = demand50), colour = "blue", alpha = 0.5) +
                  geom_line(aes(y = pasa_availability)) +
                  facet_wrap(~region) +
                  labs(x = "Date", y = "Demand / available")

skim(stpasa[[3]])

stpasa[[3]] %>% transmute(
                          day      = ymd_hms(INTERVAL_DATETIME),
                          region   = REGIONID,
                          calc_1 = CALCULATEDLOR1LEVEL,
                          calc_2 = CALCULATEDLOR2LEVEL
                          ) %>%
                filter(!is.na(calc_1) & !is.na(calc_2)) %>%
                ggplot(aes(x = day, y = calc_1)) +
                  geom_line(colour = "red", alpha=0.7)  +
                  geom_line(aes(y = calc_2), colour = "blue", alpha=0.7)  +
                  facet_wrap(~region)


stpasa[[3]] %>% transmute(
                          day      = ymd_hms(INTERVAL_DATETIME),
                          region   = REGIONID,
                          demand10 = DEMAND10,
                          demand50 = DEMAND50,
                          demand90 = DEMAND90,
                          maxsparecapacity = MAXSPARECAPACITY,
                          maxsurplusreserve = MAXSURPLUSRESERVE
                          ) %>%
                filter(!is.na(maxsparecapacity) & !is.na(maxsurplusreserve)) %>%
                ggplot(aes(x = day, y = demand10)) +
                  geom_line(colour = "blue", alpha=0.7)  +
                  geom_line(aes(y = demand50), colour = "blue", alpha = 0.7) +
                  geom_line(aes(y = demand90), colour = "blue", alpha = 0.7) +
                  geom_line(aes(y = maxsparecapacity + maxsurplusreserve), colour = "green", alpha = 1) +
                  geom_line(aes(y = maxsurplusreserve), colour = "red", alpha = 0.7) +
                  facet_wrap(~region)



# region_solutions - demand
st.region_solutions %>% filter(runtype == "OUTAGE_LRC") %>%
                ggplot(aes(x = interval_datetime, y = demand10)) + geom_line(colour = "green", alpha=0.7)  +
                  geom_line(aes(y = demand50), colour = "orange", alpha = 0.7) +
                  geom_line(aes(y = demand90), colour = "red", alpha = 0.7) +
                  geom_line(aes(y = aggregatepasaavailability), colour = "black", alpha = 1) +
                  facet_wrap(~regionid)

# interconnector_solution
st.interconnector_solutions %>%
  ggplot(aes(interval_datetime, calculatedexportlimit)) + geom_line(colour = "red") +
    geom_line(aes(y = calculatedimportlimit), colour = "green", alpha = 0.5) +
    facet_wrap(~interconnectorid)

# constraint_solution
st.constraint_solutions %>%
  ggplot(aes(interval_datetime, capacityrhs)) + geom_line() +
    facet_wrap(~constraintid)

