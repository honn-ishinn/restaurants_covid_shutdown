#### Preamble ####
# Purpose: Provide codes for selecting two similar cities as the treatment group (reopen city) and the control group (shutdown city)
# Author: Hong Shi, Yixin Guan, Babak Mokri, Hong Pan
# Date:  20 February 2021
# Contact: lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the cleaned employment data and census data in "01_employment_census_data_cleaning.R" 
#   and saved it to inputs/data

#### Workspace setup ####

library(tidyverse)
library(here)
library(ggrepel)
library(stringr)

# Read in the cleaned data

# Employment data
cleaned_statscan_employment <- readr::read_csv(here::here("inputs/data/cleaned_statscan_employment.csv"))
  
# Census data

cleaned_2016_census <- readr::read_csv(here::here("inputs/data/cleaned_2016_census.csv"))


#### City selection ####

# compare the number of observations between the cleaned_statscan_employment dataset and the cleaned_2016_census dataset

count(cleaned_statscan_employment) < count(cleaned_2016_census)

# We notice that the employment information is not available for all cities in the employment by industry dataset. 
# So we have to select the treatment city and the control city with employment information available
select_employment <- 
  cleaned_statscan_employment %>% 
  select(GEO, VALUE) %>% 
  filter(GEO != "Ottawa-Gatineau, Ontario/Quebec" & GEO != "Ottawa-Gatineau, Quebec part, Ontario/Quebec")
# Remove the Gatineau employment data since it is out of Ontario province


# We notice that the NAICS data about employment could be collected in city groups 
# ( e.g. St. Catharines and Niagara are collected in a single subgroup)
city_groups <-
  cleaned_statscan_employment %>% 
  filter(grepl("-", cleaned_statscan_employment$GEO)) # Cities within the city group are separated by "-"
head(city_groups$GEO)

# Since cities within these city groups have large differences in turns of demographics and land areas, 
# it is not proper to consider these city groups as a whole in the selection of cities, so we opt these city groups out of our study

# We would like to get the population density in one tibble for determining the selection of cities
select_census <- 
  cleaned_2016_census %>% 
  select( City = `Geographic name`, Population_Density = `Population density per square kilometre, 2016`)
head(select_census)

# We would like to get the population, land area in one tibble for determining the city similarities after the city selections
select_census_poparea <- 
  cleaned_2016_census %>% 
  select( City = `Geographic name`, Population = `Population, 2016`, Area = `Land area in square kilometres, 2016`)
head(select_census_poparea)


# split the column name in select_employment dataset to remove "Ontario" province separated by comma

select_employment$City <- str_split_fixed(select_employment$GEO, ",", 2)[,1] #[,1] means to only keeps the city names column
# Drop the GEO column 
# Ref link to drop the column: https://stackoverflow.com/questions/6286313/remove-an-entire-column-from-a-data-frame-in-r
select_employment$GEO <- NULL

# change Ottawa-Gatineau into Ottawa since already removed Gatineau 
# Ref link to reassign value:https://www.edureka.co/community/35430/how-change-the-value-variable-using-programming-data-frame
select_employment$City[select_employment$City == "Ottawa-Gatineau"] <- "Ottawa"

unique(cleaned_statscan_employment$SCALAR_FACTOR)
# Multiply the employment value by 1000 since the scalar factor is in thousands 
select_employment$Employment <- select_employment$VALUE * 1000
# Drop the VALUE column
select_employment$VALUE <- NULL
select_employment

# join two dataset to create a dataset that contains cities with population density and employment in Accommodation and food services available 

popdensity_employment <- merge(select_census, select_employment, by = "City")
head(popdensity_employment)

# Plot a Employment vs Population Density graph to detect cities with similar restaurant operating situation 
# (i.e. number of people served by restaurant staffs per square kilometers) by finding cities located closed to data points 
 
ggplot( data = popdensity_employment, mapping = aes(x = Employment, y = Population_Density)) +
  geom_point( )+
  theme_minimal() + 
  geom_label_repel(aes( label = City)) +
  geom_smooth( method = "lm", formula = y~x)


# The figure shows that Toronto has very high population density and employment in accommodation and food services, and it makes sense that Toronto is the most populous city in Canada
# Since we would like to select two cities with similar population density and employment as the treatment and control group, we remove Toronto from the graph due to no comparable restaurant operating situation with other cities.
popdensity_employment <- 
  popdensity_employment %>% 
  filter( City !="Toronto")

ggplot( data = popdensity_employment, mapping = aes(x = Employment, y = Population_Density)) +
  geom_point( )+
  theme_minimal() + 
  geom_label_repel(aes( label = City)) 
#geom_smooth( method = "lm", formula = y~x)

# As we could see from the graph, the data points representing Bratford and Peterborough lies closely with each other
# Meaning that they have similar population density and accommodation and food service employment, 
# we could select Brantford and Peterborough as the control and treatment cities.

# An brief table showing coefficients of previous plot, suggesting that the restaurant operating situations between these two cities are similar 
popdensity_employment$density_employment <- 
  popdensity_employment$Population_Density/ popdensity_employment$Employment
popdensity_employment %>% 
  select(City, density_employment) %>% 
  knitr::kable(
    col.names = c("city", "Restaurant employment operating occupacy indicator")
  )


# we would also like to compare the similarity between Brantford and Peterborough in turns of population and land area
select_census_poparea %>% 
  filter( City == "Brantford"| City == "Peterborough") %>% 
  knitr::kable(
    col.names = c("city", "population", "area")
  )
# The result shows that Brantford and Peterborough are similar cities in turns of population and area, 
# expect that Brantford is slightly bigger and more populous

# For now, we have finished the selection of cities to implement our experiment


