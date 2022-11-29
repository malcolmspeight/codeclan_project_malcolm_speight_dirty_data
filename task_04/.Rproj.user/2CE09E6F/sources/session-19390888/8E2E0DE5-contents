library(tidyverse)
library(readxl)
library(janitor)

## 2015 data
# read in data and clean variable names
candy_2015 <- read_excel("data_raw/boing-boing-candy-2015.xlsx") %>% 
  select(1:96, 115) %>% # remove unwanted columns
  clean_names()

# extract year from timestamp column then remove timestamp
  candy_2015 <- candy_2015 %>% 
    mutate(year = str_sub(timestamp, start = 1, end = 4), .before = timestamp) %>% 
    select(-timestamp)

# rename certain columns
candy_2015 <- candy_2015 %>% 
  rename("age" = "how_old_are_you",
         "going_out?" = "are_you_going_actually_going_trick_or_treating_yourself",
         "bonkers_the_candy" = "bonkers", 
         "hershey_s_dark_chocolate" = "dark_chocolate_hershey", 
         "joy_joy_mit_iodine!" = "joy_joy_mit_iodine", 
         "licorice_yes_black" = "licorice")

## age
candy_2015 <- candy_2015 %>% 
  mutate(age = as.numeric(age)) %>% # force age to be numeric
  filter(!is.na(age)) %>% # remove rows with non-numeric age value 
  filter(age >= 1 & age <= 100) # remove rows where age 
  

view(candy_2015)
glimpse(candy_2015)

  
