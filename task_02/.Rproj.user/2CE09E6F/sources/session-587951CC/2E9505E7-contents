library(tidyverse)
library(janitor)

glimpse(cake_ingredients)

## Cake ingredients
cake_ingredients <- read_csv("data_raw/cake-ingredients-1961.csv")
cake_code <- read_csv("data_raw/cake_ingredient_code.csv")

names(cake_ingredients)


col_names <- c(names(cake_ingredients))


for (colname in col_names) {
  rename(cake_ingredients, colname = case_when(
    colname == cake_code$code ~ cake_code$ingredient, 
    TRUE ~ colname
  ))
}


for (colname in col_names) {
  rename(cake_ingredients, colname = case_when(
    TRUE ~ "YES",
    colname == cake_code$code ~ cake_code$ingredient, 
  ))
}