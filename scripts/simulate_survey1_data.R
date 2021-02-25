#### Preamble ####
# Purpose: This script simulates the responses to a survey about restaurants in Toronto.
# Author: Hong Shi, Yixin Guan, Babak Mokri, Hong Pan
# Data:  "`r format(Sys.time(), '%d %B %Y')`"
# Contact: lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - None


#### Workspace setup ####
#install.packages("tibble")
library(tibble)


#### Questions ####

# Q1: Where is your restaurant located?  

# Q2: How many employees do your restaurant currently have? (Restaurant means the entity in your current location, a chain restaurant could have any entities)

# Q3: Which of the following category best describe your restaurant in terms of formality?

# Q4: On average, how much sales has you restaurant made monthly in the past three months? 

# Q5: Which best describes the nature of your restaurant? 

# Q6: How many customers could your restaurant serve at the same time? (You may skip this question if your restaurant is in quick-service)


#### Simulate questions ####

## Peterborough ##

set.seed(1225)
number_of_observation_P<-50

peterborough_data<-tibble(
  q1_city=rep("Peterborough",number_of_observation_P),
  q2_employees=sample(x=c("Less than 5","5 -10","10 - 30","30 - 50","Prefer not to say"),size = number_of_observation_P,replace = TRUE,prob = c(0.25,0.35,0.2,0.1,0.1)),
  q3_category=sample(x=c("Fine Dining","Casual Dining"),size = number_of_observation_P,replace = TRUE,prob = c(0.25,0.75)),
  q4_sales=sample(x=c("$0 - $25,000","$25,000 - $50,000","$50,000 - $80,000","$80,000 - $110,000","$110,000 - $150,000","$150,000 or above","Prefer not to say"),
                  size = number_of_observation_P,replace = TRUE,prob = c(0.22,0.3,0.15,0.1,0.03,0.0,0.2)),
  q5_nature=sample(x=c("Table-service restaurant","Quick-service restaurant"),size = number_of_observation_P,replace = TRUE, prob = c(0.5,0.5)),
  q6_customers=sample(x=c("Less than 10","10 - 20","20 - 40","40 -70","70 -100","More than 100","Prefer not to say"),size = number_of_observation_P,replace = TRUE,
                      prob = c(0.1,0.25,0.3,0.1,0.08,0.02,0.15))
)




## Brantford ##

number_of_observation_B<-50
Brantford_data<-tibble(
  q1_city=rep("Brantford",number_of_observation_B),
  q2_employees=sample(x=c("Less than 5","5 -10","10 - 30","30 - 50","Prefer not to say"),size = number_of_observation_B,replace = TRUE,prob = c(0.25,0.35,0.2,0.1,0.1)),
  q3_category=sample(x=c("Fine Dining","Casual Dining"),size = number_of_observation_B,replace = TRUE,prob = c(0.30,0.70)),
  q4_sales=sample(x=c("$0 - $25,000","$25,000 - $50,000","$50,000 - $80,000","$80,000 - $110,000","$110,000 - $150,000","$150,000 or above","Prefer not to say"),
                  size = number_of_observation_B,replace = TRUE,prob = c(0.22,0.3,0.15,0.1,0.03,0,0.2)),
  q5_nature=sample(x=c("Table-service restaurant","Quick-service restaurant"),size = number_of_observation_B,replace = TRUE, prob = c(0.5,0.5)),
  q6_customers=sample(x=c("Less than 10","10 - 20","20 - 40","40 -70","70 -100","More than 100","Prefer not to say"),size = number_of_observation_B,replace = TRUE,
                      prob = c(0.1,0.25,0.3,0.1,0.08,0.02,0.15))
)




#### Combined control and treatment groups ####
simulated_survey1_dataset <- 
  rbind(peterborough_data, Brantford_data)


#### Save and clean-up
write.csv(simulated_survey1_dataset, '~/Desktop/simulated_survey1_dataset.csv')





##








