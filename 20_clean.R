# convert to date time
cdt <- function (data) {
  data %>% mutate_at(vars(matches("INTERVAL_DATETIME|PUBLISH_DATETIME|PERIOD_ENDING|DAY|RUN_DATETIME")),
                     ymd_hms)
}
################################################################################
# MT PASA
################################################################################
mt.constraint_result      <- map_dfr(mtpasa, 3) %>% cdt
mt.constraint_summary     <- map_dfr(mtpasa, 4) %>% cdt
mt.interconnector_result  <- map_dfr(mtpasa, 5) %>% cdt
mt.lolp_result            <- map_dfr(mtpasa, 6) %>% cdt
mt.region_result          <- map_dfr(mtpasa, 7) %>% cdt
mt.region_summary         <- map_dfr(mtpasa, 8) %>% cdt
mt.region_iteration       <- map_dfr(mtpasa, 9) %>% cdt

names(mt.constraint_result)       <- str_to_lower(names(mt.constraint_result))
names(mt.constraint_summary)      <- str_to_lower(names(mt.constraint_summary))
names(mt.interconnector_result)   <- str_to_lower(names(mt.interconnector_result))
names(mt.lolp_result)             <- str_to_lower(names(mt.lolp_result))
names(mt.region_result)           <- str_to_lower(names(mt.region_result))
names(mt.region_summary)          <- str_to_lower(names(mt.region_summary))
names(mt.region_iteration)        <- str_to_lower(names(mt.region_iteration))

################################################################################
# Region data set
################################################################################

region.availability <- map_dfr(region, 3) %>% cdt

names(region.availability) <- str_to_lower(names(region.availability))

region.run_times <- unique(region.availability$publish_datetime)

################################################################################
# ST PASA
################################################################################

st.region_solutions         <- map_dfr(stpasa, 3) %>% cdt
st.interconnector_solutions <- map_dfr(stpasa, 4) %>% cdt
st.constraint_solutions     <- map_dfr(stpasa, 5) %>% cdt

names(st.region_solutions)         <- str_to_lower(names(st.region_solutions))
names(st.interconnector_solutions) <- str_to_lower(names(st.interconnector_solutions))
names(st.constraint_solutions)     <- str_to_lower(names(st.constraint_solutions))

st.run_times <- unique(st.region_solutions$run_datetime)

