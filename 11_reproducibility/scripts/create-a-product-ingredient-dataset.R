library(tidyverse)
library(juicelaundry)

# find out how many products have ingredients
sku %>% 
   select(product_id, product_desc) %>% 
   filter(!is.na(product_desc)) %>% 
   distinct() %>% 
   nrow()

# create a product-ingredient level dataset with product_id and ingredient_name
sku %>% 
   separate(
      col = product_desc, 
      sep = " / ", 
      into = str_c("ingredient_", seq(1:11))
   ) %>% 
   gather(
      ingredient_1:ingredient_11, 
      key = "ingredient_number", 
      value = "ingredient_name",
      na.rm = TRUE
   ) %>% 
   select(product_id, ingredient_name) ->
   product_ingredient

# double check that product_ingredient includes all 60 products with ingredients
product_ingredient %>% 
   select(product_id) %>% 
   distinct() %>% 
   nrow()
