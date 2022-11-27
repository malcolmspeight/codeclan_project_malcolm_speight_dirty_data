library(tidyverse)
library(readxl)
library(janitor)

## Bird data
# read in bird data and clean variable names
birds <- read_excel("data_raw/seabirds.xls", sheet = "Bird data by record ID") %>% 
  clean_names() %>% 
  rename(common_name = species_common_name_taxon_age_sex_plumage_phase, 
         scientific_name = species_scientific_name_taxon_age_sex_plumage_phase, 
         bird_count = count)

# reduce bird columns to those required
birds <- birds %>% 
  select(record_id, common_name, scientific_name, species_abbreviation, bird_count)

# clean N/A bird count values to 0 (zero)
birds <- birds %>% 
  mutate(bird_count = coalesce(bird_count, 0))

## Ship data
# read in ship data and clean variable names
ships <- read_excel("data_raw/seabirds.xls", sheet = "Ship data by record ID") %>% 
  clean_names() %>% 
  rename(latitude = lat, longitude = long)

# reduce ship columns to those required
ships <- ships %>% 
  select(record_id, latitude, longitude)

# clean N/A latitude and longitude values to 0 (zero) value
ships <- ships %>% 
  mutate(latitude = coalesce(latitude, 0), 
         longitude = coalesce(longitude, 0))

# join bird and ship data together in to one table
bird_obs <- left_join(birds, ships, by = "record_id")
  
# write data to clean data folder
write_csv(bird_obs, "data_clean/bird_obs.csv")


