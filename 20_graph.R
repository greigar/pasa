
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


