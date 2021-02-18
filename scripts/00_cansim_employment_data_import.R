#### Preamble ####
# Purpose: Use cansim to get the employment by industry, annual, census metropolitan areas data
# Author: Hong Shi, Yixin Guan, Babak Mokri, Hong Pan
# Date:  20 February 2021
# Contact: lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace set-up ####

# Get data from Statistics Canada through package cansim

# install.packages("cansim")

library(tidyverse)
library(cansim)
library(here)


#### Get Data ####

# We get the Employment by industry, annual, census metropolitan areas from Statistics Canada:
# https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=1410009801

statscan_employment <- get_cansim("282-0131") # This is the CANSIM table code of the employment data 

# have a glance of the data
head(statscan_employment)

# save the raw data of Employment by industry, annual, census metropolitan areas 
write_csv(statscan_employment, here::here("inputs/data/raw_statscan_employment.csv"))

