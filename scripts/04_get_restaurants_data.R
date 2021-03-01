#### Preamble ####
# Purpose: Sampling Method: Get a list of restaurants of Brantford and Peterborough using Yelp API
# Author: Yixin Guan, Hong Shi, Babak Mokri, Hong Pan
# Date:  21 February 2021
# Contact: yixin.guan@mail.utoronto.ca, lancehong.shi@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Need to have downloaded the "mapping_SAC_postalcode.csv" in "03_mapping_SAC_postalcode.R" and saved it to inputs/data


####  Workspace Setup ####

library(here)
library(tidyverse)
library(httr)
library(xml2)



# In order to make an request using Yelp API, a Yelp developer account and a API Key have to be created. 

token <- "Please enter your own token here"
# Setup for searching restaurants in Brantford, Ontario

yelp <- "https://api.yelp.com"
term <- "restaurants"
Brantford_location <- "Brantford, Ontario"
categories <- "Restaurants"
limit <- 50
radius <- 40000

restaurantName <- vector()
postalCode <- vector()
restaurantAddress <- vector()
phoneNum <- vector()

# Since each page only showed 50 results, and there are more resturuants in the two cities. We use "offset" to find all the records. 

# Get all 133 restaurants in Brantford
for(n in seq(0, 133, 50)) {
  url <- modify_url(yelp, path = c("v3", "businesses", "search"),
                    query = list(term = term, location = Brantford_location, 
                                 limit = limit,
                                 radius = radius,
                                 offset = n))
  res <- GET(url, add_headers('Authorization' = paste("bearer", token)))
  
  results <- content(res)
  len <- length(results$businesses)
  for(i in 1:len) {
    address <- paste(results$businesses[[i]]$location$display_address[[1]], results$businesses[[i]]$location$display_address[[2]], results$businesses[[i]]$location$display_address[[3]])
    restaurantName <- append(restaurantName, results$businesses[[i]]$name)
    # Unify the format of postal code to join the Yelp tibble and the PCCF tibble.
    postalCode <- append(postalCode, gsub(" ", "", results$businesses[[i]]$location$zip_code, fixed = TRUE))
    restaurantAddress <- append(restaurantAddress, address)
    phoneNum <- append(phoneNum, results$businesses[[i]]$display_phone)
  }
}

# Use the same methods to get all 173 restaurants in Peterborough. 

Peterborough_location <- "Peterborough, Ontario"

for(n in seq(0, 173, 50)) {
  url <- modify_url(yelp, path = c("v3", "businesses", "search"),
                    query = list(term = term, location = Peterborough_location, 
                                 limit = limit,
                                 radius = radius,
                                 offset = n))
  res <- GET(url, add_headers('Authorization' = paste("bearer", token)))
  
  results <- content(res)
  len <- length(results$businesses)
  for(i in 1:len) {
    address <- paste(results$businesses[[i]]$location$display_address[[1]], results$businesses[[i]]$location$display_address[[2]], results$businesses[[i]]$location$display_address[[3]])
    restaurantName <- append(restaurantName, results$businesses[[i]]$name)
    # Unify the format of postal code to join the Yelp tibble and the PCCF tibble. 
    postalCode <- append(postalCode, gsub(" ", "", results$businesses[[i]]$location$zip_code, fixed = TRUE))
    restaurantAddress <- append(restaurantAddress, address)
    phoneNum <- append(phoneNum, results$businesses[[i]]$display_phone)
  }
}

# Make to tibble for all the restaurants selected. 

restaurantList <- tibble(
  restaurantName = restaurantName, 
  restaurantAddress = restaurantAddress,
  restaurantPostalCode = postalCode,
  phoneNumber = phoneNum
)

head(restaurantList)

# Save the restaurant data of these two cities

write_csv(restaurantList, here::here("inputs/data/restaurant_data.csv"))





