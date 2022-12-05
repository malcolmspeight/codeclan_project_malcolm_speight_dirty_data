library(tidyverse)
library(janitor)

## read in cake ingredients and cake code 
cake_ingredients <- read_csv("data_raw/cake-ingredients-1961.csv")
cake_code <- read_csv("data_raw/cake_ingredient_code.csv")

# pivot longer cake_ingredients to allow join with cake_code table
cake_ingredients_pivoted <- cake_ingredients %>% 
pivot_longer(cols = "AE":"ZH", names_to = "code", values_to = "amount")
view(cake_ingredients_pivoted)

# join cake_ingredients with cake_code and clean names
cake_ingredients_and_code <- left_join(cake_ingredients_pivoted, cake_code, by = "code") 

# move columns in joined table to make contents more readable
cake_ingredients_and_code <- cake_ingredients_and_code %>% 
  relocate(ingredient, .before = amount) %>% 
  clean_names() # clean names 

# write data to clean data folder 
write_csv(cake_ingredients_and_code, "data_clean/cake_ingredients_clean.csv")
