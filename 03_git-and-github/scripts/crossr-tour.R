# press Ctrl + 1 to open a new script

# remove.packages("CrossR")

devtools::install_github("jeffboichuk/CrossR")
# install.packages("devtools") # press Alt + Up to move this above

library(CrossR)
library(tidyverse)

CrossR
# after typing CrossR press F1 to see the documentation for CrossR. Give Steve a
# shout-out

shortcuts

# Two comments: 
# 1. Same as you'll find in RStudio's keyboard shortcut quick reference if you
#    press Shift + Alt + K
# 2. Changed the order of some keystrokes and added spaces around the keystrokes

find_s 
# after typing find_s press F1 and then Shift + Ctrl + 3 to maximize the help
# pane. From here, oscillate back and forth between the source and help panes
# with Shift + Ctrl + 1 and Shift + Ctrl + 3. Finally land on Shift + Ctrl + 3
# and read the documentation for find_shortcuts

find_shortcuts("pipe")

# ask someone with a windows pc what they see?

shortcuts %>% 
   count(category, sort = TRUE)

get_encouragement()