source("helpers.R")

################################################################################
# ST PASA
################################################################################
stpasa <- read_pasa_files("_STPASA_")

st.region_solutions         <- map_dfr(stpasa, 3) %>% cdt
st.interconnector_solutions <- map_dfr(stpasa, 4) %>% cdt
st.constraint_solutions     <- map_dfr(stpasa, 5) %>% cdt

st.run_times <- unique(st.region_solutions$run_datetime)

rm(stpasa)
