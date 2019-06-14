#
# EDA for unit solutions
#

nsw_duids <- aemo_units %>% filter(REGIONID == "NSW1"  & FUEL_TYPE %in% c("Black Coal", "Liquid Fuel", "Brown Coal", "Gas")) %>% select(DUID, CAPACITY) %>% unique

nsw_unit_solutions <- inner_join(ndt.unit_solutions, nsw_duids)


ggplot(nsw_unit_solutions, aes(x = SETTLEMENTDATE, y = TOTALCLEARED, colour = DUID)) + geom_line()

nsw_unit_solutions %>% filter(DUID == "ER02") %>% ggplot(aes(x = SETTLEMENTDATE, y = TOTALCLEARED, colour = DUID)) + geom_line() + geom_line(aes(y = CAPACITY))

