
library(tidyverse)
library(magrittr)

library(electionsBR)

# Set timeout limit to 10 minutes due to data download from TSE's repo

options(timeout = 10 * 60)

# For the first time you'll need to download the data  first

elec_2016 <- electionsBR::candidate_local(year = 2016, uf = "RJ")
elec_2020 <- electionsBR::candidate_local(year = 2020, uf = "RJ")

# Saves the data for reduced import time

elec_2016 <- saveRDS(elec_2016, file = "elec_2016.rds")
elec_2020 <- saveRDS(elec_2020, file = "elec_2020.rds")

# Import saved files

elec_2016 <- read_rds(file = "elec_2016.rds")
elec_2020 <- read_rds(file = "elec_2020.rds")

elec_2016 <- elec_2016[, names(elec_2016) != "NR_PROTOCOLO_CANDIDATURA"]
elec_2020 <- elec_2020[, names(elec_2020) != "NR_PROTOCOLO_CANDIDATURA"]

# Binding the data and later transforming it to the wide format

data <- bind_rows(elec_2016, elec_2020)

data %<>% 
  filter(NM_UE == "RIO DE JANEIRO" & CD_CARGO == 13) %>%
  select(ANO_ELEICAO, NR_CPF_CANDIDATO, SG_PARTIDO)

data_wide <- data %>%
  distinct(ANO_ELEICAO, NR_CPF_CANDIDATO, .keep_all = T) %>%
  pivot_wider(names_from = ANO_ELEICAO, values_from = SG_PARTIDO, 
              names_prefix = "SG_PARTIDO_")

# tidy graph like data format

data_wide %<>% filter(!is.na(SG_PARTIDO_2016) & !is.na(SG_PARTIDO_2020))

connect <- data_wide %>%
  select(SG_PARTIDO_2016, SG_PARTIDO_2020) %>%
  mutate(VALUE = 1)

nodes <- c(connect$SG_PARTIDO_2016, connect$SG_PARTIDO_2020) %>% 
  as.tibble() %>%
  group_by(value) %>%
  summarise(n = n()) %>%
  select(SG_PARTIDO = value, N = n)

# VIZ



