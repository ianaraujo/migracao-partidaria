
library(tidyverse)

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

elec_2016 <- read_rds(elec_2016, file = "elec_2016.rds")
elec_2020 <- read_rds(elec_2020, file = "elec_2020.rds")

# Cleaning data...

