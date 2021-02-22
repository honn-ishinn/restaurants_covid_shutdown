#### Preamble ####
# Purpose: Sampling Method: Get the list of restaurants for sampling
# Author: Yixin Guan, Hong Shi, Babak Mokri, Hong Pan
# Date:  21 February 2021
# Contact: yixin.guan@mail.utoronto.ca, lancehong.shi@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Need to have downloaded the "mapping_SAC_postalcode.csv" in "03_mapping_SAC_postalcode.R" and saved it to inputs/data
# Need to have downloaded the "restaurant_data.csv" in "04_get_restaurants_data.R" and saved it to inputs/data


####  Workspace Setup ####

library(here)
library(tidyverse)
library(kableExtra)

# Read in the cleaned data

# Mapping data

mapping <- readr::read_csv(here::here("inputs/data/mapping_SAC_postalcode.csv"))

# Restaurant data

restaurantList <- readr::read_csv(here::here("inputs/data/restaurant_data.csv"))

# Join the mapping data and restaurant data to ensure restaurants we would sample are indeed in Brantford and Peterborough


joined_tibble <- inner_join(
  mapping,
  restaurantList,
  by = c("postal_Code" = "restaurantPostalCode"))

# check number of restaurants within these two cities after the inner join
# Note: SAC 543 stands for Brantford, SAC 529 stands for Peterborough

joined_tibble %>%
  group_by(SAC) %>%
  summarise(count=n())

set.seed(8888)

#Randomly find 100 restaurants whose postal code is in Brantford CMA and the phone number is not missing.  
brantfordRandomRestaurant <- joined_tibble %>%
  filter(SAC == "543" & phoneNumber != '') %>%
  sample_n(100)

#Randomly find 100 restaurants whose postal code is in Peterborough CMA and the phone number is not missing.  
peterboroughRandomRestaurant <- joined_tibble %>%
  filter(SAC == "529" & phoneNumber != '') %>%
  sample_n(100)

#create a list to give the survey staff with the name, phone number, city and the postal codes of the restaurants
finalSurveyList <- union(brantfordRandomRestaurant, peterboroughRandomRestaurant) %>%
  mutate(CMA = if_else(SAC=='529', 'peterborough', 'Brantford')) %>%
  select(restaurantName, restaurantAddress, postal_Code, CMA, phoneNumber)


# Save the survey list for survey staffs to contact restaurants 

write.csv(finalSurveyList, here("outputs/surveylist/restaurant_survey_list.csv"))

#### Create a simulated table showing restaurant responses####

tibble(
  'City' = list('Brantford', 'Peterborough'), 
  'Survey Administered' = list(100, 100),
  'Total Sample Collected' = list(45, 48),
  'Telephone Survey Collected' = list(40, 41),
  'Online Survey Collected' = list(5, 7)
) %>%
  kbl(caption = 'Sampling Results Summary') %>%
  kable_styling()







