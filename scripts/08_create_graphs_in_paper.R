#### Preamble ####
# Purpose: This script create relevant tables and graphs used in the paper.
# Author:  Hong Pan, Hong Shi, Yixin Guan, Babak Mokri
# Data:  "25 February 2021"
# Contact:  hong.pan@mail.utoronto.ca， lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the "simulated_first_survey.csv" in "06_simulate_first_survey_responses.R" and saved it to outputs/survey
# - Need to have downloaded the "simulated_second_survey.csv" in "07_simulate_second_survey_responses.R" and saved it to outputs/survey




#### Workspace setup ####

library(here)
library(tidyverse) # used for data manipulation
library(ggpubr) # for combing figures in one graph
library(ggrepel)
library(kableExtra)
library(janitor)

#install.packages("finalfit")

library(finalfit)
# Import Dataset

# First Survey
simulated_survey1_dataset <- read.csv( here('outputs/survey/simulated_first_survey.csv'))

# Second Survey
simulated_dataset<-read_csv(here('outputs/survey/simulated_second_survey.csv'))

#################   First Survey   ###############

# get the summary statistics of the first survey
# Referenced the following link to create this amazing summary table: https://finalfit.org/articles/all_tables_examples.html
# Referenced the following link to change the order of rows: https://stackoverflow.com/questions/32593434/r-change-row-order

f_survey <- simulated_survey1_dataset %>% 
  summary_factorlist("q1_city", c("q3_category","q5_nature","q2_employees","q4_sales","q6_customers"),
                     p = FALSE, 
                     add_dependent_label = TRUE,
                     dependent_label_prefix = "",
                     add_col_totals = TRUE,
                     include_row_missing_col = FALSE,
                     col_totals_rowname = "",
                     total_col = FALSE) %>%
  rename(
    Responses = ` `
  )
f_survey$q1_city <- NULL
# Manually change the order of the factor levels to have a better visualization 
f_survey <- f_survey[c(1:5,9,8,6,7,10,11,13,14,15,12,16,21,17,18,19,20,22),] %>% 
  mutate(` ` = c("Total Samples","Restaurant Category","","Restaurant Nature","","Number of Employees","","","","","Average Monthly Sales","","","","","","Restaurant Capacity","","","","",""))
# Create column name to describe the survey questions
kable( f_survey[,c(4,1,2,3)],caption = "Summary Statistics of the First Survey",
       booktabs = TRUE,
       valign='t') 



#################   Second Survey   ###############

# Question3 How many employees have you laid off because of COVID 19? 

data.frame(table(simulated_dataset$q3_layoff,simulated_dataset$q1_city))%>%
  ggplot(aes(Var1, Freq,fill=Var2)) +
  theme_minimal()+
  geom_bar(stat = "identity",position = position_dodge(), width = 0.7)+
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Number of Responses")+
  xlab("Number of Laid-offs")+
  ggtitle("Layoff Situation due to COVID 19")+
  guides(fill=guide_legend(title="City"))


# Referenced the following link to reorder responses
#https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html

# Question4 How was your total sales volume during Oct to Dec 2020 compared to July to Sept 2020?

q4_table <- data.frame(table(simulated_dataset$q4_total_sales,simulated_dataset$q1_city))
data.frame(table(simulated_dataset$q4_total_sales,simulated_dataset$q1_city))%>%
  mutate(Var1 = fct_relevel(Var1,"Prefer not to say", "Decreased more than 10%","Decreased 5% ~ 10%","Roughly unchanged","Increased 5% ~ 10%","Increased more than 10%")) %>% 
  ggplot(aes(Var1, Freq,fill=Var2)) +
  theme_minimal()+
  geom_bar(stat = "identity",width = 0.8, position = position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Number of Responses")+
  xlab("Total Sale Change")+
  ggtitle("Total Sales Volume Change Oct to Dec vs July to Sept in 2020")+
  guides(fill=guide_legend(title="City"))+
  coord_flip()

#Question 5. How was your total costs volume during Oct to Dec 2020 compared to July to Sept 2020?


q5_table <- data.frame(table(simulated_dataset$q5_total_cost,simulated_dataset$q1_city))

# Even though there is no responses for "Decreased by more than 25%" in both city, we still need to include them as a option in our survey
q5_table <-  q5_table %>% add_row(Var1 = "Decreased by more than 25%", Var2 = "Peterborough", Freq = 0) %>%
  add_row(Var1 = "Decreased by more than 25%", Var2 = "Brantford", Freq = 0)
q5_table%>%
  mutate(Var1 = fct_relevel(Var1,"Prefer not to say","Decreased by more than 25%", "Decreased by 5% ~ 25%","Roughly unchanged","Increased by  5% ~ 25%","Increased by more than 25%")) %>% 
  ggplot(aes(Var1, Freq,fill=Var2)) +
  theme_minimal()+
  geom_bar(stat = "identity",width = 0.8, position = position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Number of Responses")+
  xlab("Total Cost Change")+
  ggtitle("Total Cost Volume Change Oct to Dec vs July to Sept in 2020")+
  guides(fill=guide_legend(title="City"))+
  coord_flip()

# Question 8. If current conditions continue, how long do you expect your business to survive before you will have to close down permanently?

data.frame(table(simulated_dataset$q8_survive,simulated_dataset$q1_city))%>%
  mutate(Var1 = fct_relevel(Var1 ,"Unknown","Longer than 6 months","3 to 6 months","Less than 3 months")) %>% 
  ggplot(aes(Var1, Freq,fill=Var2)) +
  theme_minimal()+
  geom_bar(stat = "identity",width = 0.8, position = position_dodge()) +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Number of Responses")+
  xlab("Expected Survival Time")+
  ggtitle("Expected Survival Time if Current Situation Continues")+
  guides(fill=guide_legend(title="City"))+
  coord_flip()

# Question 10. If COVID-19 situation stops now, how many months do you expect your business to recover to the previous level?

data.frame(table(simulated_dataset$q10_recover,simulated_dataset$q1_city,simulated_dataset$q2_type))%>%
  mutate(Var1 = fct_relevel(Var1 ,"Prefer not to say","More than 18 months","12 to 18 months","7 to 12 months","Six months or less")) %>% 
  ggplot(aes(Var1, Freq,fill=Var2)) +
  theme_minimal()+
  geom_bar(stat = "identity",width = 0.8, position = position_dodge())+
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~Var3)+
  ylab("Number of responses")+
  xlab("Number of months")+
  ggtitle("Expected Recovery Time Back to pre-COVID Situation")+
  guides(fill=guide_legend(title="City"))+
  coord_flip()

# Question 11. To what extent do you feel the government financial support programs helped your business survive? (1 being terrible, 5 being excellent.)

simulated_dataset %>%
  tabyl(q1_city, q11_rate_support)%>%
  adorn_totals("row", name = "Total")%>%
  adorn_percentages("row")%>%
  adorn_pct_formatting(digits=2)%>%
  adorn_ns()%>%
  adorn_title("combined",row_name = "City", col_name = "Rating")%>%
  rename(
    `Terrible` = `1`,
    `Poor` = `2`,
    `Fair` = `3`,
    `Good` = `4`,
    `Excellent` = `5`
  ) %>% 
  kable(align = 'ccccccc', caption = 'Helpfulness of Government Financial Support Programs on Restaurants') %>% 
  kable_styling(latex_options = "hold_position")

# Question 14 How much loans have you received for the COVID-19 related reasons ?

data.frame(table(simulated_dataset$q14_loans,simulated_dataset$q1_city))%>%
  mutate(Var1 = fct_relevel(Var1 ,"Prefer not to say","More than $50,000","$40,000 ~ $50,000","$20,000 ~ $40,000","$0 ~ $20,000")) %>% 
  ggplot(aes(Var1, Freq,fill=Var2)) +
  geom_bar(stat = "identity", width = 0.8, position = position_dodge())+
  ylab("Number of responses")+
  xlab("Loan value")+
  ggtitle("How much loans have you received for the COVID-19 related reasons?")+
  guides(fill=guide_legend(title="City"))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 0))+
  coord_flip()

# Question 15 Including the above governmental programs (if applicable), how much grants have you received for COVID related reasons?

data.frame(table(simulated_dataset$q15_grants,simulated_dataset$q1_city))%>%
  mutate(Var1 = fct_relevel(Var1 ,"Prefer not to say","More than $40,000","$20,000 ~ $40,000","$10,000 ~ $20,000","$0 ~ $10,000")) %>% 
  ggplot(aes(Var1, Freq,fill=Var2)) +
  geom_bar(stat = "identity", width = 0.8, position = position_dodge())+
  ylab("Number of responses")+
  xlab("Grant value")+
  ggtitle("Grants Received for COVID-19 Related Reasons")+
  guides(fill=guide_legend(title="City"))+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 0))+
  coord_flip()

