library(tidyverse)
library(readr)
library(janitor)

## Decathlon data
# read in data
decathlon_data <- read_rds("data_raw/decathlon.rds") %>% 
  rownames_to_column("athlete") %>% # flip existing row names to a new 'athlete' column
  clean_names() # clean variable names

# change variable names, data type of 'competition' and format of athlete name values
decathlon_data <- decathlon_data %>% 
  rename("100m" = "x100m", 
         "400m" = "x400m",
         "110m_hurdle" = "x110m_hurdle",
         "1500m" = "x1500m") %>% 
  mutate(competition = as.character(competition)) %>% 
  mutate(athlete = str_to_title(athlete))

# write data to clean data folder 
write_csv(decathlon_data, "data_clean/decathlon_clean.csv")





