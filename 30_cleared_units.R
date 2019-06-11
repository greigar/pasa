nsw_duids <- aemo_units %>% filter(REGIONID == "NSW1"  & FUEL_TYPE %in% c("Black Coal", "Liquid Fuel", "Brown Coal", "Gas")) %>% select(DUID, CAPACITY) %>% unique

nsw_unit_solutions <- inner_join(ndt.unit_solutions, nsw_duids, by = c("duid" = "DUID"))


ggplot(nsw_unit_solutions, aes(x = settlementdate, y = totalcleared, colour = duid)) + geom_line()

nsw_unit_solutions %>% filter(duid == "ER02") %>% ggplot(aes(x = settlementdate, y = totalcleared, colour = duid)) + geom_line() + geom_line(aes(y = CAPACITY))

