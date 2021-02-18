#### Preamble ####
# Purpose: This script simulates the responses to a survey about restaurants in Toronto.
# Author: Hong Shi, Yixin Guan, Babak Mokri, Hong Pan
# Data:  "`r format(Sys.time(), '%d %B %Y')`"
# Contact: lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca, hong.pan@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - None



#### Workspace setup ####




#### Simulate questions ####
# Q1: Which city are you in? 
# Q2: Which best describes the nature of your restaurant?
# Q3: How many employees have you laid off because of COVID 19?
# Q4: How was your total sales volume this month compare to the last month? 
# Q5: To what extent, the number of your orders have decreased after the pandemic?
# Q6: To what extent, your revenue changed after the pandemic?
# Q7: If current conditions continue, how long do you expect your business to survive before you will have to close down permanently? 
# Q8: Which best describes the current profitability of your overall operations.
# Q9: How many months do you expect it will take your business to return to profitability?
# Q10:How much loans have you received for the COVID related reasons?
# Q11:Does your foodservice business require additional financial support beyond what is currently available to you through government programs in order to survive?
# Q12:Is your business receiving the Canada Emergency Wage Subsidy(CEWS)?
# Q13: Have signed up for the lease subsidy introduced by the government last year?
# Q14: Including the above governmental programs (if applicable), how much grants have you received for the COVID related reasons?
# Q15: To what extent, your costs have increased after the pandemic?


# Do this one for treated and one for control and then bring them together

#### Treatment group(Brantford) ####
set.seed(8888)
number_of_treat<-50 #Simulate 50 observations for each city. According to the data scraping from Yelp, Peterborough and Brantford both have around 160 restaurants. From our research, we estimated that 50 of 100 restaurants randomly selected would reply to our survey.

treat_data<-tibble(
  group=rep("Treated", number_of_treat),
  q1_city=rep("Brantford",number_of_treat),
  q2_type=sample(x=c('Table-service',"Quick-service"),size=number_of_treat,replace = TRUE,prob = c(0.5, 0.5)),
  q3_layoff=sample(x=c("0","1-4","5-10","More than 10","Prefer not to say"),number_of_treat,replace = TRUE, prob = c(0.11,0.48,0.35,0.03,0.03)),
  q4_total_sales=sample(c("Earn more than 10%","Earn 5% ~ 10%","Roughly unchanged","Lose 5% ~ 10%","Lose more than 10%","Prefer not to say"), number_of_treat, replace = TRUE, 
                     prob = c(0.02,0.11,0.23, 0.34, 0.31,0)),
  q5_order=sample(c("Decreased more than 25%","Decreased by 5% – 25%","Roughly unchanged","Increased by  5% – 25%","Increased more than 25%","Prefer not to say"),
                  number_of_treat, replace = TRUE, prob = c(0.2, 0.33, 0.28, 0.15, 0.04, 0)),
  q6_revenue=sample(c("Decreased more than 25%","Decreased by 5% – 25%","Roughly unchanged","Increased by  5% – 25%","Increased more than 25%","Prefer not to say"),
                    number_of_treat, replace = TRUE, prob = c(0.42, 0.31, 0.11, 0.05, 0.02, 0.09)),
  q7_survive=sample(c("Less than 3 months","3 to 6 months","Longer than 6 months","Unknown","Prefer not to say"),
                    number_of_treat, replace = TRUE, prob = c(0.4, 0.12, 0.32, 0.11, 0.05)),
  q8_operation=sample(c("Operating at a loss","Breaking even","Profit between 0% and 2%","Profit between 2% and 5%","Profit of 5% or more","Prefer not to say"),
                      number_of_treat, replace = TRUE, prob = c(0.52, 0.2, 0.09, 0.1, 0.03, 0.06)),
  q9_recover=sample(c("Six months or less","Between seven months to a year","Between a year and 18 months","More than 18 months","Prefer not to say"),
                    number_of_treat, replace = TRUE, prob = c(0.08, 0.23, 0.44, 0.17, 0.08)),
  q11_cost=sample(c("More than 50%","25% - 50% ","0 – 25%","Our costs have decreased after the pandemic","Prefer not to say"),
                  number_of_treat, replace = TRUE, prob = c(0.07, 0.25, 0.53, 0.1, 0.05)),
  q12_support=sample(c("Yes","No",'I do not know',"Prefer not to say"),number_of_treat, replace = TRUE, prob = c(0.75, 0.08, 0.17,0)),
  q13_CEWS=sample(c("Yes","No","I do not know","Prefer not to say"), number_of_treat, replace = TRUE, prob = c(0.8, 0.17, 0.03, 0))
)





#### Control Group(Peterborough) ####

number_of_contral<-50

control_data<-tibble(
  group=rep("Control", number_of_contral),
  q1_city=rep("Peterborough",number_of_contral),
  q2_type=sample(x=c('Table-service',"Quick-service"),size=number_of_contral,replace = TRUE,prob = c(0.5, 0.5)),
  q3_layoff=sample(x=c("0","1-4","5-10","More than 10","Prefer not to say"),number_of_contral,replace = TRUE, prob = c(0.48,0.36,0.1,0.03,0.03)),
  q4_total_sales=sample(c("Earn more than 10%","Earn 5% ~ 10%","Roughly unchanged","Lose 5% ~ 10%","Lose more than 10%","Prefer not to say"), number_of_contral, replace = TRUE, 
                        prob = c(0.06, 0.44, 0.32, 0.08, 0.1, 0.0)),
  q5_order=sample(c("Decreased more than 25%","Decreased by 5% – 25%","Roughly unchanged","Increased by  5% – 25%","Increased more than 25%","Prefer not to say"),
                  number_of_contral, replace = TRUE, prob = c(0.13, 0.27, 0.32, 0.2, 0.08, 0.0)),
  q6_revenue=sample(c("Decreased more than 25%","Decreased by 5% – 25%","Roughly unchanged","Increased by  5% – 25%","Increased more than 25%","Prefer not to say"),
                    number_of_contral, replace = TRUE, prob = c(0.25, 0.42, 0.17, 0.1, 0.03, 0.03)),
  q7_survive=sample(c("Less than 3 months","3 to 6 months","Longer than 6 months","Unknown","Prefer not to say"),
                    number_of_contral, replace = TRUE, prob = c(0.08, 0.27, 0.51, 0.11, 0.03)),
  q8_operation=sample(c("Operating at a loss","Breaking even","Profit between 0% and 2%","Profit between 2% and 5%","Profit of 5% or more","Prefer not to say"),
                      number_of_contral, replace = TRUE, prob = c(0.44, 0.25, 0.1, 0.12, 0.06, 0.03)),
  q9_recover=sample(c("Six months or less","Between seven months to a year","Between a year and 18 months","More than 18 months","Prefer not to say"),
                    number_of_contral, replace = TRUE, prob = c(0.13, 0.31, 0.33, 0.2, 0.03)),
  q11_cost=sample(c("More than 50%","25% - 50% ","0 – 25%","Our costs have decreased after the pandemic","Prefer not to say"),
                  number_of_contral, replace = TRUE, prob = c(0.04, 0.16, 0.65, 0.13, 0.02)),
  q12_support=sample(c("Yes","No",'I do not know',"Prefer not to say"),number_of_contral, replace = TRUE, prob = c(0.63, 0.2, 0.17, 0.0)),
  q13_CEWS=sample(c("Yes","No","I do not know","Prefer not to say"), number_of_contral, replace = TRUE, prob = c(0.75, 0.21, 0.04, 0.0))
)



#### Combined control and treatment groups ####
simulated_dataset <- 
  rbind(control_data, treat_data)


#### Save and clean-up
write_csv(simulated_dataset, '~/Desktop/simulated_data.csv')



























