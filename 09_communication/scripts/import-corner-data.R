library(tidyverse)
library(googledrive)
library(here)

options(warnPartialMatchArgs = FALSE)

# create a folder for the data
dir.create(here("09_communication", "data"))

# get the data from google drive and save it within the folder created
drive_auth()

drive_download(
  file = "corner-restaurant",
  path = here("09_communication", "data", "corner-restaurant"),
  type = "csv",
  overwrite = TRUE
)

# read in the data
here("09_communication", "data", "corner-restaurant.csv") %>% 
  read_csv() ->
  corner_restaurant

# analyze the data
corner_restaurant %>% 
  ggplot(aes(x = restaurant_type)) +
  geom_bar()

corner_restaurant %>% 
  ggplot(aes(x = aftertax_listed)) +
  geom_bar()