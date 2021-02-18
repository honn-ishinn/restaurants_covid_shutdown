#### Preamble ####
# Purpose: Clean the cansim employment data and the Canadian 2016 census data
# Author: Hong Shi, Yixin Guan, Babak Mokri, Hong Pan
# Date:  20 February 2021
# Contact: lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# 1. Need to have downloaded the raw data in "00_cansim_employment_data_import.R" and saved it to inputs/data
# 2. Need to have downloaded the Population and Dwelling Count Highlight Tables, 2016 Census data from Statistics Canada
#    with the filter on geography: provinces and territories to Ontario and save "T31120210212123500.CSV" to inputs/data

#### Workspace setup ####

library(tidyverse)
library(here)


#### Read in the raw data ####

# The NAICS employment data
statscan_employment <- readr::read_csv(here::here("inputs/data/raw_statscan_employment.csv"))

# Read in the Population and Dwelling Count Highlight Tables, 2016 Census downloaded from Statistics Canada

# Unfortunately, we did not find a convenient way to scape (Requires many manipulations of cleanning data) 
# or directly load the 2016 Cencus data in R
# so we manually downloaded the data from Statistics Canada and saved it into inputs/data 
# The name of the original table is "T31120210212123500.CSV"

# Link: https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/hlt-fst/pd-pl/Table.cfm?Lang=Eng&T=311&SR=1&S=87&O=A&RPP=9999&PR=35#details-panel2
# Note: We applied the filter on geography: provinces and territories to Ontario

raw_2016_census <- readr::read_csv(here::here("inputs/data/T31120210212123500.CSV")) 


#### Data cleaning ####

# For NAICS employment data

# We would like to filter out the employment information:
# 1. In Ontario, 
# 2. Belongs to accommodation and food services category according to (NAICS) the North American Industry Classification System
# 3. In 2016 ( since we would use population density data in 2016 to perform city selection as treatment city and control city)
cleaned_statscan_employment <- 
  statscan_employment %>% 
  filter(
    grepl("Ontario", statscan_employment$GEO) &
      grepl("Accommodation and food services", statscan_employment$`North American Industry Classification System (NAICS)`) &
      grepl("^2016", statscan_employment$REF_DATE)
  )

# save the cleaned employment data
write_csv(cleaned_statscan_employment, here::here("inputs/data/cleaned_statscan_employment.csv"))


# For 2016 Census data

# We would like to filter out the census information:
# 1. In "City" of the CSD, DPL (census subdivision, designated place) type
cleaned_2016_census <- 
  raw_2016_census %>% 
  filter(
    grepl("City", raw_2016_census$`CSD, DPL Type`) 
  )

# save the cleaned census data
write_csv(cleaned_2016_census, here::here("inputs/data/cleaned_2016_census.csv"))

