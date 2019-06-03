# mutate chars to date time
convert_date_time <- function (data) { data %>% mutate_at(c("DAY", "RUN_DATETIME", "PERIOD_ENDING"), ymd_hms) }

################################################################################
# MT PASA
################################################################################
mt.constraint_result      <- map_dfr(mtpasa, 3)
mt.constraint_summary     <- map_dfr(mtpasa, 4)
mt.interconnector_result  <- map_dfr(mtpasa, 5)
mt.lolp_result            <- map_dfr(mtpasa, 6)
mt.region_result          <- map_dfr(mtpasa, 7)
mt.region_summary         <- map_dfr(mtpasa, 8)
mt.region_iteration       <- map_dfr(mtpasa, 9)

# Convert date char to date
mt.constraint_result$DAY              <- ymd_hms(mt.constraint_result$DAY)
mt.constraint_result$RUN_DATETIME     <- ymd_hms(mt.constraint_result$RUN_DATETIME)
mt.constraint_summary$DAY             <- ymd_hms(mt.constraint_summary$DAY)
mt.constraint_summary$RUN_DATETIME    <- ymd_hms(mt.constraint_summary$RUN_DATETIME)
mt.interconnector_result$DAY          <- ymd_hms(mt.interconnector_result$DAY)
mt.interconnector_result$RUN_DATETIME <- ymd_hms(mt.interconnector_result$RUN_DATETIME)
mt.lolp_result$DAY                    <- ymd_hms(mt.lolp_result$DAY)
mt.lolp_result$RUN_DATETIME           <- ymd_hms(mt.lolp_result$RUN_DATETIME)
mt.region_result$DAY                  <- ymd_hms(mt.region_result$DAY)
mt.region_result$RUN_DATETIME         <- ymd_hms(mt.region_result$RUN_DATETIME)
mt.region_summary$PERIOD_ENDING       <- ymd_hms(mt.region_summary$PERIOD_ENDING)
mt.region_summary$RUN_DATETIME        <- ymd_hms(mt.region_summary$RUN_DATETIME)
mt.region_iteration$PERIOD_ENDING     <- ymd_hms(mt.region_iteration$PERIOD_ENDING)
mt.region_iteration$RUN_DATETIME      <- ymd_hms(mt.region_iteration$RUN_DATETIME)

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

region.availability <- map_dfr(region, 3)

# Convert date char to date
region.availability$DAY              <- ymd_hms(region.availability$DAY)
region.availability$PUBLISH_DATETIME <- ymd_hms(region.availability$PUBLISH_DATETIME)

names(region.availability) <- str_to_lower(names(region.availability))

region.run_times <- unique(region.availability$publish_datetime)

################################################################################
# ST PASA
################################################################################

st.region_solutions         <- map_dfr(stpasa, 3)
st.interconnector_solutions <- map_dfr(stpasa, 4)
st.constraint_solutions     <- map_dfr(stpasa, 5)

# Convert date char to date
st.region_solutions$INTERVAL_DATETIME          <- ymd_hms(st.region_solutions$INTERVAL_DATETIME)
st.region_solutions$RUN_DATETIME               <- ymd_hms(st.region_solutions$RUN_DATETIME)
st.interconnector_solutions$INTERVAL_DATETIME  <- ymd_hms(st.interconnector_solutions$INTERVAL_DATETIME)
st.constraint_solutions$INTERVAL_DATETIME      <- ymd_hms(st.constraint_solutions$INTERVAL_DATETIME)

names(st.region_solutions)         <- str_to_lower(names(st.region_solutions))
names(st.interconnector_solutions) <- str_to_lower(names(st.interconnector_solutions))
names(st.constraint_solutions)     <- str_to_lower(names(st.constraint_solutions))

st.run_times <- unique(st.region_solutions$run_datetime)

