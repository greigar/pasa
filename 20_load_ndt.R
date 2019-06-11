source("helpers.R")

################################################################################
# NEXT DAY TRADING
################################################################################
next_day_trading   <- read_pasa_files("_NEXT_DAY_TRADING_")
ndt.unit_solutions <- map_dfr(next_day_trading, 2) %>% cdt

