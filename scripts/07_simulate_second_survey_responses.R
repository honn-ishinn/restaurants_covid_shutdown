#### Preamble ####
# Purpose: This script simulates the responses of the second survey about impact of COVID on restaurant business
#          in Peterborough and Brantford after three months of reopening and shutdown, respectively.
# Author:  Hong Pan, Hong Shi, Yixin Guan, Babak Mokri
# Data:  "22 February 2021"
# Contact:  hong.pan@mail.utoronto.ca， lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - None


#### Workspace setup ####

#install.packages("tibble")
library(tibble)  # a nice way to create data frames
library(here)


#### Questions ####

# Q1: Which city are you in?  
# (Simulate around 50 observations for each city. According to the data scraping from Yelp, Peterborough and Brantford both have around 160 restaurants. From our research, we estimated that around 50 of 100 restaurants randomly selected would reply to our survey.)

# Q2: Which best describes the nature of your restaurant?
# (According to the dataset [Statistics Canada,2017], for each city, half of the data is simulated as table-service, and the other half is simulated as quick-service.)

# Q3: How many employees have you laid off because of COVID 19?
# (According to the data [Statistics Canada,2020 ], small layoffs have the highest proportion for restaurants of different sizes. From research, we know that Ontario has more small or medium-sized restaurants, to give a relatively small percentage for layoff more than 5 people.)

# Q4: How was your total sales volume during Oct to Dec 2020 compared to July to Sept2020?
# (The results from surveying restaurants' total sales from quarter 2[Restaurants Canada Q2, 2020] and quarter 3[Restaurants Canada Q3,2020] help to simulate the data.The better situation for reopen city.)

# Q5: How was your total costs volume during Oct to Dec 2020 compared to July to Sept2020?
# (We know from the article that due to the pandemic, the price of vegetables has risen by more than 4%. The information displayed in the Q2 and Q3 reports is about the extent to which the restaurant hopes to increase the menu price to cover the cost. In conclusion, both cities face almost the same challenge, but reopen city will be more suffering by paying wages, etc.)

# Q6: To what extent, the number of your orders have decreased after the pandemic? 

# Q7: To what extent, your revenue changed after the pandemic?

# Q8: If current conditions continue, how long do you expect your business to survive before you will have to close down permanently? 
#(Compared to the data shown in the quarter 2 report [Restaurants Canada Q2, 2020]  and the artilce[Ruess,2020], we can imply that restaurants locating in the reopened city would survive longer.)

# Q9: Which best describes the current profitability of your overall operations?
#(The results from surveying restaurants' total sales from quarter 2[Restaurants Canada Q2, 2020] and quarter 3[Restaurants Canada Q3,2020] help to simulate the data.The better situation for reopen city.)

# Q10: How many months do you expect your business to recover to the previous level? 
#(The article[Wasser, M.,2020] is helpful for us to simulate data for this question. Restaurants in open city can recover faster than in shutdown city.)

# Q11:To what extent do you feel the government financial support programs helped your business survive? 
#(According to the quarter 3 report[Restaurants Canada, Q3, 2020], we can simulate data by giving a similar situation for both cities. )

# Q12:Have signed up for the lease subsidy introduced by the government last year? 

# Q13: Is your business receiving the Canada Emergency Wage Subsidy(CEWS)?
#(The result shown in quarter 3 report[Restaurants Canada, Q3, 2020])

# Q14: How much loans have you received for the COVID related reasons ?

# Q15:Including the above governmental programs (if applicable), how much grants have you received for the COVID related reasons?
#(From the article[Advisor’s Edge, 2021], we know Ontario offers restaurants at least $10,000. )






#### Simulte questions ####

# Do this one for treated and one for control and then bring them together


#### Control group(Brantford) ####
set.seed(105)
number_of_control<-45     #Simulate around 50 observations for each city. According to the data scraping from Yelp, Peterborough and Brantford both have around 160 restaurants. From our research, we estimated that around 50 of 100 restaurants randomly selected would reply to our survey.

control_data<-tibble(
  group=rep("Control", number_of_control),
  q1_city=rep("Brantford",number_of_control),
  q2_type=sample(x=c('Table-service',"Quick-service"),size=number_of_control,replace = TRUE,prob = c(0.5, 0.5)),
  q3_layoff=sample(x=c("0","1-4","5-10","More than 10","Prefer not to say"),number_of_control,replace = TRUE, prob = c(0.11,0.48,0.35,0.03,0.03)),
  q4_total_sales=sample(c("Increased more than 10%","Increased 5% ~ 10%","Roughly unchanged","Decreased 5% ~ 10%","Decreased more than 10%","Prefer not to say"), number_of_control, replace = TRUE, 
                        prob = c(0.02,0.05,0.21, 0.48, 0.18,0.06)),
  q5_total_cost=sample(c("Decreased more than 25%","Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased by more than 25% ","Prefer not to say"),number_of_control,
                       replace = TRUE, prob = c(0,0.06, 0.45, 0.37, 0.1, 0.02)),
  q6_order=sample(c("Decreased more than 25%","Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased more than 25%","Prefer not to say"),
                  number_of_control, replace = TRUE, prob = c(0.15, 0.31, 0.28, 0.12, 0.04, 0.1)),
  q7_revenue=sample(c("Decreased more than 25%","Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased more than 25%","Prefer not to say"),
                    number_of_control, replace = TRUE, prob = c(0.42, 0.31, 0.11, 0.11, 0.02, 0.03)),
  q8_survive=sample(c("Less than 3 months","3 to 6 months","Longer than 6 months","Unknown","Prefer not to say"),
                    number_of_control, replace = TRUE, prob = c(0.5, 0.28, 0.08, 0.09, 0.05)),
  q9_profitability=sample(c("Operating at a loss","Breaking even","Profit between 1% and 5%","Profit of 5% or more","Prefer not to say"),
                          number_of_control, replace = TRUE, prob = c(0.52, 0.2, 0.19, 0.03, 0.06)),
  q10_recover=sample(c("Six months or less","7 to 12 months","12 to 18 months","More than 18 months","Prefer not to say"),
                     number_of_control, replace = TRUE, prob = c(0.08, 0.23, 0.27, 0.34, 0.08)),
  q11_rate_support=sample(c(1,2,3,4,5,"Prefer not to say"),
                          number_of_control, replace = TRUE, prob = c(0.02, 0.04, 0.13, 0.34, 0.47,0)),
  q12_lease=sample(c("Yes","No",'I do not know',"Prefer not to say"),number_of_control, replace = TRUE, prob = c(0.73, 0.15, 0.09,0.03)),
  q13_CEWS=sample(c("Yes","No","I do not know","Prefer not to say"), number_of_control, replace = TRUE, prob = c(0.53, 0.27, 0.1, 0.1)),
  q14_loans=sample(c("$0 ~ $20,000","$20,000 ~ $40,000","$40,000 ~ $50,000","More than $50,000", "Prefer not to say"),number_of_control,replace = TRUE,
                   prob = c(0.48,0.3, 0.1, 0.02, 0.1)),
  q15_grants=sample(c("$0 ~ $10,000","$10,000 ~ $20,000","$20,000 ~ $40,000","More than $40,000","Prefer not to say"),
                    number_of_control,replace = TRUE, prob = c(0.32, 0.47, 0.11, 0.07, 0.03))
)





#### Treatment Group(Peterborough) ####

number_of_treated<-48     #Simulate around 50 observations for each city. According to the data scraping from Yelp, Peterborough and Brantford both have around 160 restaurants. From our research, we estimated that around 50 of 100 restaurants randomly selected would reply to our survey.

treat_data<-tibble(
  group=rep("Treatment", number_of_treated),
  q1_city=rep("Peterborough",number_of_treated),
  q2_type=sample(x=c('Table-service',"Quick-service"),size=number_of_treated,replace = TRUE,prob = c(0.5, 0.5)),
  q3_layoff=sample(x=c("0","1-4","5-10","More than 10","Prefer not to say"),number_of_treated,replace = TRUE, prob = c(0.48,0.36,0.1,0.03,0.03)),
  q4_total_sales=sample(c("Increased more than 10%","Increased 5% ~ 10%","Roughly unchanged","Decreased 5% ~ 10%","Decreased more than 10%","Prefer not to say"), number_of_treated, replace = TRUE, 
                        prob = c(0.12,0.44,0.2, 0.08, 0.16,0)),
  q5_total_cost=sample(c("Decreased more than 25%","Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased by more than 25% ","Prefer not to say"),number_of_treated,
                       replace = TRUE, prob = c(0, 0.03, 0.32, 0.43, 0.15, 0.07)),
  q6_order=sample(c("Decreased more than 25%","Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased more than 25%","Prefer not to say"),
                  number_of_treated, replace = TRUE, prob = c(0.08, 0.15, 0.24, 0.39, 0.1, 0.04)),
  q7_revenue=sample(c("Decreased more than 25%","Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased more than 25%","Prefer not to say"),
                    number_of_treated, replace = TRUE, prob = c(0.25, 0.22, 0.26, 0.1, 0.14, 0.03)),
  q8_survive=sample(c("Less than 3 months","3 to 6 months","Longer than 6 months","Unknown","Prefer not to say"),
                    number_of_treated, replace = TRUE, prob = c(0.08, 0.27, 0.57, 0.05, 0.03)),
  q9_profitability=sample(c("Operating at a loss","Breaking even","Profit between 1% and 5%","Profit of 5% or more","Prefer not to say"),
                          number_of_treated, replace = TRUE, prob = c(0.38, 0.25, 0.28, 0.06, 0.03)),
  q10_recover=sample(c("Six months or less","7 to 12 months","12 to 18 months","More than 18 months","Prefer not to say"),
                     number_of_treated, replace = TRUE, prob = c(0.23, 0.41, 0.23, 0.1, 0.03)),
  q11_rate_support=sample(c(1,2,3,4,5,"Prefer not to say"),
                          number_of_treated, replace = TRUE, prob = c(0.05, 0.09, 0.28, 0.35, 0.23, 0)),
  q12_lease=sample(c("Yes","No",'I do not know',"Prefer not to say"),number_of_treated, replace = TRUE, prob = c(0.7, 0.18, 0.12, 0)),
  q13_CEWS=sample(c("Yes","No","I do not know","Prefer not to say"), number_of_treated, replace = TRUE, prob = c(0.75, 0.18, 0.07, 0)),
  q14_loans=sample(c("$0 ~ $20,000","$20,000 ~ $40,000","$40,000 ~ $50,000","More than $50,000", "Prefer not to say"),number_of_treated,replace = TRUE,
                   prob = c(0.28, 0.4, 0.16, 0.08, 0.08)),
  q15_grants=sample(c("$0 ~ $10,000","$10,000 ~ $20,000","$20,000 ~ $40,000","More than $40,000","Prefer not to say"),
                    number_of_treated,replace = TRUE, prob = c(0.47, 0.36, 0.09, 0.04, 0.04))
)



#### Combined control and treatment groups ####
simulated_dataset <- 
  rbind(control_data, treat_data)


#### Save and clean-up

write.csv(simulated_dataset, here('outputs/survey/simulated_second_survey.csv'))






#### Reference when stimulating the dataset####

# Advisor’s Edge. (2021, January 23). Ontario offers small businesses grants of up to $20,000. https://www.advisor.ca/news/economic/ontario-offers-small-businesses-grants-of-up-to-20000/

# Restaurants Canada. (2020, June). Restaurant outlook survey Q2 2020. https://members.restaurantscanada.org/wp-content/uploads/2015/09/Q2-ROS-Final.pdf

# Ruess, H. (2020, April 29). Canadian Chamber/StatCan major survey on business conditions amid COVID-19 shows economic clock is ticking. Canadian Chamber of Commerce. https://www.canadianbusinessresiliencenetwork.ca/news-and-insights/2020/04/29/canadian-chamber-statcan-major-survey-of-business-conditions-amid-covid-19-shows-economic-clock-is-ticking/

# Restaurants Canada. (2020, September). Restaurant outlook survey Q3 2020. https://members.restaurantscanada.org/wp-content/uploads/2015/09/ROS-Q3-2020-Final.pdf

# Statistics Canada. (2017, February). Canadian business counts, December 2016. https://www150.statcan.gc.ca/n1/en/daily-quotidien/170215/dq170215e-eng.pdf?st=MTUknOhq

# Statistics Canada. (2020, April 29). Add/Remove data - Percentage of workforce laid off because of COVID-19, by business characteristics. Percentage of Workforce Laid off Because of COVID-19, by Business Characteristics 1. https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3310023201

# Wasser, M. (2020, July 6). Most restaurants will need continued government support to survive Canada’s recovery from COVID-19. Restaurants Canada. https://www.restaurantscanada.org/industry-news/most-restaurants-will-need-continued-government-support-to-survive-canadas-recovery-from-covid-19/










