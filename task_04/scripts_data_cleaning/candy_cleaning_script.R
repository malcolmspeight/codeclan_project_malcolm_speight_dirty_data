library(tidyverse)
library(readxl)
library(janitor)

view(candy_2015)
glimpse(candy_2015)

## 2015 data
# read in data and clean variable names
candy_2015 <- read_excel("data_raw/boing-boing-candy-2015.xlsx") %>% 
  mutate(how_old_are_you = as.numeric(how_old_are_you)) # force age to be numeric
  select(1:96, 115) %>% # remove unwanted columns
  clean_names()

# rename certain columns
candy_2015 <- candy_2015 %>% 
  rename("age" = "how_old_are_you",
         "going_out?" = "are_you_going_actually_going_trick_or_treating_yourself",
         "bonkers_the_candy" = "bonkers", 
         "hershey_s_dark_chocolate" = "dark_chocolate_hershey", 
         "joy_joy_mit_iodine!" = "joy_joy_mit_iodine", 
         "licorice_yes_black" = "licorice")

# extract year from timestamp column then remove timestamp
candy_2015 <- candy_2015 %>% 
  mutate(year = str_sub(timestamp, start = 1, end = 4), .before = timestamp) %>% 
  select(-timestamp)
  
