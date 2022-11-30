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
         "100_grand_bar" = "x100_grand_bar",
         "bonkers_the_candy" = "bonkers", 
         "hershey_s_dark_chocolate" = "dark_chocolate_hershey", 
         "joy_joy_mit_iodine!" = "joy_joy_mit_iodine", 
         "licorice_yes_black" = "licorice")

# pivot candy columns to rows
candy_2015 <- candy_2015 %>% 
  pivot_longer(cols = 4:97, # the candy columns
               names_to = "candy",
               values_to = "rating")


# add gender and country columns to match 2016 and 2017 to allow union
candy_2015 <- candy_2015 %>% 
  mutate(gender = NA_character_, 
         country = NA_character_)


########################################################################
## 2016 data

# read in data and clean variable names
candy_2016 <- read_excel("data_raw/boing-boing-candy-2016.xlsx") %>% 
  select(1:5, 7:11, 13:78, 80:106) %>% # remove unwanted columns
  clean_names()

# extract year from timestamp column then remove timestamp
candy_2016 <- candy_2016 %>% 
  mutate(year = str_sub(timestamp, start = 1, end = 4), .before = timestamp) %>% 
  select(-timestamp)

# rename columns
candy_2016 <- candy_2016 %>% 
  rename("going_out?" = "are_you_going_actually_going_trick_or_treating_yourself",
         "100_grand_bar" = "x100_grand_bar",
         "independent_m_ms" = "third_party_m_ms", 
         "gender" = "your_gender", 
         "age" = "how_old_are_you",
         "country" = "which_country_do_you_live_in")

# pivot candy columns to rows
candy_2016 <- candy_2016 %>% 
  pivot_longer(cols = 6:103, # the candy columns
               names_to = "candy",
               values_to = "rating")


# # country - clean country values
# candy_2016 <- candy_2016 %>% 
#   mutate(country = str_to_title(country)) %>% 
#   mutate(country = case_when(
#     str_detect(country, "(?i)\\bus\\b") ~ "USA",
#     str_detect(country, "(?i)u.s.") ~ "USA",
#     str_detect(country, "(?i)\\busa\\b") ~ "USA",
#     str_detect(country, "(?i)u.s.a.") ~ "USA",
#     str_detect(country, "(?i)ussa") ~ "USA",
#     str_detect(country, "(?i)america") ~ "USA",
#     str_detect(country, "(?i)united state") ~ "USA",
#     str_detect(country, "(?i)united stetes") ~ "USA",
#     str_detect(country, "(?i)united sates") ~ "USA",
#     str_detect(country, "(?i)units states") ~ "USA",
#     str_detect(country, "(?i)units sates") ~ "USA",
#     str_detect(country, "(?i)units stetes") ~ "USA",
#     str_detect(country, "(?i)merica") ~ "USA",
#     str_detect(country, "(?i)murica") ~ "USA",
#     str_detect(country, "(?i)trumpistan") ~ "USA",
#     str_detect(country, "(?i)yoo") ~ "USA",
#     str_detect(country, "(?i)eua") ~ "USA",
#     str_detect(country, "(?i)england") ~ "UK",
#     str_detect(country, "(?i)united kingdom") ~ "UK",
#     str_detect(country, "(?i)united kindom") ~ "UK",
#     str_detect(country, "(?i)uk") ~ "UK",
#     str_detect(country, "(?i)netherlands") ~ "The Netherlands",
#     str_detect(country, "(?i)españa") ~ "Spain",
#     str_detect(country, "(?i)korea") ~ "South Korea",
#     str_detect(country, "(?i)cascadia") ~ NA_character_,
#     str_detect(country, "(?i)neverland") ~ NA_character_,
#     str_detect(country, "(?i)this one") ~ NA_character_,
#     str_detect(country, "(?i)tropical") ~ NA_character_,
#     str_detect(country, "(?i)one") ~ NA_character_,
#     str_detect(country, "(?i)somewhere") ~ NA_character_,
#     str_detect(country, "(?i)god") ~ NA_character_,
#     str_detect(country, "(?i)above") ~ NA_character_,
#     str_detect(country, "(?i)denial") ~ NA_character_,
#     str_detect(country, "3") ~ NA_character_,
#     str_detect(country, "4") ~ NA_character_,
#     str_detect(country, "5") ~ NA_character_,
#     TRUE ~ country
#   ))




#############################################################################
## 2017 data

# read in data and clean variable names
candy_2017 <- read_excel("data_raw/boing-boing-candy-2017.xlsx") %>% 
  select(2:5, 7:11, 13:80, 82:109) %>% # remove unwanted columns
  clean_names()

# remove Excel prefix from names
names(candy_2017) <- substring(names(candy_2017), 4)

# rename columns
candy_2017 <- candy_2017 %>% 
  rename("going_out?" = "going_out",
         "anonymous_brown_globs_that_come_in_black_and_orange_wrappers" = 
         "anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes")

# insert year column
candy_2017 <- candy_2017 %>% 
  mutate(year = "2017", .before = "going_out?")

# pivot candy columns to rows
candy_2017 <- candy_2017 %>% 
  pivot_longer(cols = 6:106, # the candy columns
               names_to = "candy",
               values_to = "rating")


#############################################################################

# join the 3 years of data into one table
candy_data = bind_rows(candy_2015, candy_2016, candy_2017)
glimpse(candy_data)
view(candy_data)

# age
candy_data <- candy_data %>% 
  mutate(age = as.numeric(age)) %>%  # force age to be numeric
  mutate(age = case_when(            # replace extreme ages with NA
    age < 1 ~ NA_real_,
    age > 100 ~ NA_real_,
    TRUE ~ age
  ))

# gender
candy_data <- candy_data %>% 
  mutate(gender = case_when(
    gender == "" ~ NA_character_, # replace blank values with NA
    TRUE ~ gender
  ))

# country - clean country values
candy_data <- candy_data %>% 
  mutate(country = str_to_title(country)) %>% 
  mutate(country = case_when(
    str_detect(country, "(?i)\\bus\\b") ~ "USA",
    str_detect(country, "(?i)\\bu\\bs\\b") ~ "USA",
    str_detect(country, "(?i)\\bu\\bs") ~ "USA",
    str_detect(country, "(?i)u\\.s\\.") ~ "USA",
    str_detect(country, "(?i)\\busa\\b") ~ "USA",
    str_detect(country, "(?i)u\\.s\\.a\\.") ~ "USA",
    str_detect(country, "(?i)ussa") ~ "USA",
    str_detect(country, "(?i)usaa") ~ "USA",
    str_detect(country, "(?i)\\busas\\b") ~ "USA",
    str_detect(country, "(?i)usausausa") ~ "USA",
    str_detect(country, "(?i)america") ~ "USA",
    str_detect(country, "(?i)\\bunited s") ~ "USA",
    str_detect(country, "(?i)\\bunits s") ~ "USA",
    str_detect(country, "(?i)\\bstates\\b") ~ "USA",
    str_detect(country, "(?i)alaska") ~ "USA",
    str_detect(country, "(?i)california") ~ "USA",
    str_detect(country, "(?i)carolina") ~ "USA",
    str_detect(country, "(?i)pittsburgh") ~ "USA",
    str_detect(country, "(?i)jersey") ~ "USA",
    str_detect(country, "(?i)york") ~ "USA",
    str_detect(country, "(?i)merica") ~ "USA",
    str_detect(country, "(?i)murica") ~ "USA",
    str_detect(country, "(?i)murrika") ~ "USA",
    str_detect(country, "(?i)amerca") ~ "USA",
    str_detect(country, "(?i)trumpistan") ~ "USA",
    str_detect(country, "(?i)insanity") ~ "USA",
    str_detect(country, "(?i)yoo") ~ "USA",
    str_detect(country, "(?i)ud") ~ "USA",
    str_detect(country, "(?i)eua") ~ "USA",
    str_detect(country, "(?i)england") ~ "UK",
    str_detect(country, "(?i)scotland") ~ "UK",
    str_detect(country, "(?i)united kingdom") ~ "UK",
    str_detect(country, "(?i)united kindom") ~ "UK",
    str_detect(country, "(?i)uk") ~ "UK",
    str_detect(country, "(?i)u\\.k\\.") ~ "UK",
    str_detect(country, "(?i)endland") ~ "UK",
    str_detect(country, "(?i)can") ~ "Canada",
    str_detect(country, "(?i)netherlands") ~ "The Netherlands",
    str_detect(country, "(?i)españa") ~ "Spain",
    str_detect(country, "(?i)korea") ~ "South Korea",
    str_detect(country, "(?i)uae") ~ "UAE",
    str_detect(country, "(?i)atlantis") ~ NA_character_,
    str_detect(country, "(?i)cascadia") ~ NA_character_,
    str_detect(country, "(?i)earth") ~ NA_character_,
    str_detect(country, "(?i)europe") ~ NA_character_,
    str_detect(country, "(?i)neverland") ~ NA_character_,
    str_detect(country, "(?i)\\bknow\\b") ~ NA_character_,
    str_detect(country, "(?i)\\bfear\\b") ~ NA_character_,
    str_detect(country, "(?i)narnia") ~ NA_character_,
    str_detect(country, "(?i)this one") ~ NA_character_,
    str_detect(country, "(?i)tropical") ~ NA_character_,
    str_detect(country, "(?i)one") ~ NA_character_,
    str_detect(country, "(?i)somewhere") ~ NA_character_,
    str_detect(country, "(?i)god") ~ NA_character_,
    str_detect(country, "(?i)above") ~ NA_character_,
    str_detect(country, "(?i)denial") ~ NA_character_,
    str_detect(country, "1") ~ NA_character_,
    str_detect(country, "3") ~ NA_character_,
    str_detect(country, "4") ~ NA_character_,
    str_detect(country, "5") ~ NA_character_,
    str_detect(country, "(?i)\\ba\\b") ~ NA_character_,
    TRUE ~ country
  ))

