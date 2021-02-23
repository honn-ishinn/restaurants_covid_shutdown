#### Preamble ####
# Purpose: This script create relavent graphs used in the paper.
# Author:  Hong Pan, Hong Shi, Yixin Guan, Babak Mokri
# Data:  "22 February 2021"
# Contact:  hong.pan@mail.utoronto.ca， lancehong.shi@mail.utoronto.ca, yixin.guan@mail.utoronto.ca, b.mokri@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the "simulated_restaurant_data.csv" in "06_simulate_survey_responses.R" and saved it to outputs/survey




#### Workspace setup ####

library(here)
library(tidyverse) # used for data manipulation
library(ggpubr) ##for combing figures in one graph
library(ggrepel)
library(kableExtra)



# Referenced the following link to reorder reponses
#https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html