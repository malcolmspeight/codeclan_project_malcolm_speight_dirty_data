library(tidyverse)
library(readxl)
library(janitor)

view(candy_2015)
glimpse(candy_2015)

## 2015 data
# read in data and clean variable names
candy_2015 <- read_excel("data_raw/boing-boing-candy-2015.xlsx") %>% 
  select(1:96, 115) %>% # remove unwanted columns
  clean_names() 




