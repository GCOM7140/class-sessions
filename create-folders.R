library(tidyverse)
library(here)

# create a vector with the titles for each class lesson in it 
lesson_titles <- c(
   "course-overview",
   "group-project-overview",
   "git-and-github",
   "data-transformation",
   "data-visualization",
   "exploratory-data-analysis",
   "data-wrangling",
   "data-wrangling",
   "reproducibility",
   "communication",
   "final-preparations-for-the-group-project",
   "final-preparations-for-the-group-project",
   "final-exam",
   "group-project-presentations"
)

# create a vector of folder names for each class lesson
lesson_folder_names <- c(1:14) %>% 
   str_pad(2, pad = "0") %>% 
   str_c("_") %>% 
   str_c(lesson_titles)

# create folders for each class lesson
map(lesson_folder_names, dir.create)

# copy the README template and paste it into each class-lesson folder 
file.copy(
   rep(here("99_template", "README.Rmd"), 13), 
   here(lesson_folder_names[1:14], "README.Rmd"),
   overwrite = TRUE
)

# create a vector of subfolder names
subfolder_names <- c(
   "01_readings",
   "02_scripts",
   "03_slides"
)

# create these subfolders within each class-lesson folder
map(
   file.path(rep(lesson_folder_names, each = 3), subfolder_names), 
   dir.create
)

