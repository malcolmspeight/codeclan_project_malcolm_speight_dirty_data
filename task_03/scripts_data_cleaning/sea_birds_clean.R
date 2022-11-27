library(tidyverse)
library(readxl)
library(janitor)

glimpse(birds)
view(birds)
glimpse(ships)
view(ships)

# read in bird data and clean variable names
birds <- read_excel("data_raw/seabirds.xls", sheet = "Bird data by record ID") %>% 
  clean_names() %>% 
  rename(common_name = species_common_name_taxon_age_sex_plumage_phase, 
         scientific_name = species_scientific_name_taxon_age_sex_plumage_phase)

# reduce bird columns to those required
birds <- birds %>% 
  select(record_id, common_name, scientific_name, species_abbreviation, count)

# read in ship data and clean variable names
ships <- read_excel("data_raw/seabirds.xls", sheet = "Ship data by record ID") %>% 
  clean_names() %>% 
  rename(latitude = lat, longitude = long)

# reduce ship columns to those required
ships <- ships %>% 
  select(record_id, latitude, longitude)


  



