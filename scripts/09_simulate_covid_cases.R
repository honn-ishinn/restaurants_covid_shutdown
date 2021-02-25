#### Preamble ####
# Purpose: This script simulate the covid cases from October to December in 2020 in Peterborough and Brantford and plot the covid trend graph.
# Author:  Hong Shi, Hong Pan, Yixin Guan, Babak Mokri
# Data:  "25 February 2021"
# Contact: lancehong.shi@mail.utoronto.ca, hong.pan@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - None 



#### Workspace setup ####

library(tidyverse)
library(here)

#### Simulate the covid cases ####

set.seed(9)
# We assume the reopening in Peterborough to have higher reported COVID cases each day, 
# there are 92 days from October to December, we divide them into half and expect more reported covid cases in later half period

p_first46days <- rnorm(n = 46, mean = 5, sd = 3) %>% round(digits = 0) %>% abs()
p_last46days <- rnorm(n = 46, mean = 8, sd = 4) %>% round(digits = 0) %>% abs()


b_first46days <- rnorm(n = 46, mean = 2.5, sd = 2) %>% round(digits = 0) %>% abs()
b_last46days <- rnorm(n = 46, mean = 3.5, sd = 2) %>% round(digits = 0) %>% abs()


p_daily <- c(p_first46days,p_last46days)
b_daily <- c(b_first46days,b_last46days)

# Referenced the following link to get the approximate COVID cases in late September, 2020
# https://localcovidtracker.ca/
p_case <- 160
b_case <- 180
p_track <- c(0)
b_track <- c(0)

# Referenced the following link to append the value into vector
# https://stackoverflow.com/questions/22235809/append-value-to-empty-vector-in-r
for (i in 1:(length(p_daily)-1))
  p_track[i+1] <- p_track[i]+p_daily[i] 

for (i in 1:(length(b_daily)-1))
  b_track[i+1] <- b_track[i]+b_daily[i]

# total confirmed covid cases
p_total <- p_case + p_track
b_total <- b_case +b_track

track_date <- seq(as.Date("2020/10/01"), as.Date("2020/12/31"), by = "day")

# create the tibble of simulate cumulative covid cases

covid_tracking <- 
  data.frame(tibble(
    track_date = track_date,
    covid_cases_p = p_total,
    covid_cases_b= b_total
  ))

# save the simulated covid cases data

write.csv(covid_tracking, here('inputs/data/simulated_covid_data.csv'))

#### Plot the covid trend graph of these two cities ####

covid_tracking <- readr::read_csv(here('inputs/data/simulated_covid_data.csv'))

ggplot(data=covid_tracking,aes(x=track_date))+
  geom_smooth(aes(y=covid_cases_p,color="Peterborough"))+
  geom_smooth(aes(y=covid_cases_b,color="Brantford"))+
  theme_minimal()+
  scale_color_manual("City",breaks = c("Peterborough","Brantford"),
                     values = c("red","blue"))+
  xlab("Tracking date")+
  scale_y_continuous("Cumulative number of confirmed cases",limits=c(0,800))+
  labs(title = "Confirmed COVID-19 cases in Peterborough and Brantford")+
  scale_x_date(date_labels = "%Y %b %d")+
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(color=guide_legend(override.aes=list(fill=NA)))



