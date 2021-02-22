#### Preamble ####
# Purpose: Sampling Method: Get mapping document for CMA and postal code
# Author: Yixin Guan, Hong Pan, Hong Shi, Babak Mokri
# Date:  21 February 2021
# Contact: yixin.guan@mail.utoronto.ca, hong.pan@mail.utoronto.ca, lancehong.shi@mail.utoronto.ca, b.mokri@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# Need to have downloaded the Postal Code Conversion File (PCCF) 
# UofT library Login Required: 
# https://mdl.library.utoronto.ca/sites/default/files/mdldata/restricted/canada/national/statcan/postalcodes/pccf/2016/2020nov/pccfNat_fccpNat_112020.zip
# Then saved the file as "pccf.txt" into "inputs/data"

#### Workspace Setup ####

library(here)
library(tidyverse)



#### Getting mapping document for CMA and postal code ####

# Postal Code Conversion File (PCCF), Reference Guide:
# https://mdl.library.utoronto.ca/sites/default/files/mdldata/open/canada/national/statcan/postalcodes/pccf/2016/2020nov/PCCF_202011-eng.pdf

# Postal Code Conversion File (PCCF) - Login Required:
# https://mdl.library.utoronto.ca/sites/default/files/mdldata/restricted/canada/national/statcan/postalcodes/pccf/2016/2020nov/pccfNat_fccpNat_112020.zip

# In order to get a list of postal codes in a CMA, PCCF is required and downloaded. The first five lines are showed below.

pccf_txt <- readLines(here("inputs/data/pccf.txt"))
pccf_txt[1:5]

# According to the Reference Guide, the first 6 characters are postal code. 
# Statistical Area Classification(SAC) code (incluides CMA/CA) starts from the 99th characters and followed by 3 characters. 
# Postal code and and SAC are extract when each line is gone through.

postalCode <- 0
#fsa <- 0
#CSDname <- 0
SAC <- 0

for(i in 1:length(pccf_txt)) {
  postalCode[i] <- substr(pccf_txt[i],1,6)
  #  fsa[i] <- substr(pccf_txt[i],7,9)
  #  CSDname[i] <- substr(pccf_txt[i],23,92)
  SAC[i] <- substr(pccf_txt[i],99,101)
}

# A tibble is created based on the postal code and SAC. According to the ArcGIS, Peterborough and Brantford have a SAC of 529 and 543 respectively. 
# Thus, the tibble is filtered based on the SAC mentioned above. 

mapping <- tibble(
  postal_Code = postalCode, 
  #  fsa = fsa, 
  #  CSDname = CSDname,
  SAC = SAC) %>%
  filter(SAC == "543" | SAC == "529") %>%
  distinct()

# save the mapping data of postal code and SAC

write_csv(mapping, here::here("inputs/data/mapping_SAC_postalcode.csv"))






