library(tidyverse)
library(googledrive)
library(lubridate)
library(here)

options(warnPartialMatchArgs = FALSE)

# create folders for the data and daily outputs
dir.create(here("10_group-project-prep", "data"), showWarnings = FALSE)
dir.create(here("10_group-project-prep", "outputs"), showWarnings = FALSE)
dir.create(here("10_group-project-prep", "outputs", today()), showWarnings = FALSE)


# import the data, read it into R, and wrangle it -------------------------
# get the data from google drive and save it within the folder created
drive_auth()

drive_download(
  file = "tjl-instagram",
  path = here("10_group-project-prep", "data", "tjl-instagram"),
  type = "xlsx",
  overwrite = TRUE
)

# read the data into your working environment
here("10_group-project-prep", "data", "tjl-instagram.xlsx") %>% 
  readxl::read_xlsx() ->
  tjl_instagram

# create a variable equal to the number of posts that tjl has posted to
# instagram at a given point in time
tjl_instagram %>% 
  arrange(timestamp) %>% 
  mutate(
    rolling_post_count = row_number()
  ) ->
  tjl_instagram

# plot the trajectory of tjl's instagram usage ----------------------------

# find out how long it took tjl to reach 500 and then 1000 posts (in years) 
tjl_instagram %>% 
  filter(rolling_post_count  %in% c(1, 500, 1000)) %>% 
  mutate(
    time_span = (timestamp - lag(timestamp)) / 
      dyears(1) %>% 
      round(0)
  ) %>% 
  select(timestamp, rolling_post_count, time_span)

# create tibbles to annotate with
one_to_500 <- 
  tibble(
    timestamp = mean(
      c(as.POSIXct("2013-04-17"), as.POSIXct("2017-04-03"))
    ),
    rolling_post_count = 550,
    label = "Your added your first 500 posts over the course of 4 years..."
  )

five_to_1000 <- 
  tibble(
    timestamp = mean(
      c(as.POSIXct("2017-04-03"), as.POSIXct("2018-12-19"))
    ),
    rolling_post_count = 75,
    label = "...and your second 500 over 
    the course of only 1.7 years."
  )

# plot the trajectory of tjl's instagram usage with a line graph
tjl_instagram %>% 
  ggplot(aes(x = timestamp, y = rolling_post_count)) +
  # add annotations
  geom_segment(
    x = -Inf, xend = as.POSIXct("2017-04-03"), y = 500, yend = 500,
    color = "grey50"
  ) +
  geom_segment(
    x    = as.POSIXct("2017-04-03"), 
    xend = as.POSIXct("2017-04-03"),
    y    = -Inf, 
    yend = 500,
    color = "grey50"
  ) +
  geom_segment(
    x    = -Inf, 
    xend = as.POSIXct("2018-12-19"),
    y    = 1000, 
    yend = 1000,
    color = "grey50"
  ) +
  geom_segment(
    x    = as.POSIXct("2018-12-19"), 
    xend = as.POSIXct("2018-12-19"),
    y    = -Inf, 
    yend = 1000,
    color = "grey50"
  ) +
  geom_text(
    data    = one_to_500,
    mapping = aes(label = label),
    vjust   = "top",
    hjust   = "center",
    family  = "serif",
    size    = 5,
    color   = "grey33"
  ) +
  geom_text(
    data    = five_to_1000,
    mapping = aes(label = label),
    vjust   = "top",
    hjust   = "center",
    family  = "serif",
    size    = 5,
    color   = "grey33"
  ) +
  geom_line(size = 1.5) +
  coord_cartesian(ylim = c(0, 1200)) +
  scale_x_datetime(
    date_breaks = "1 year",
    date_labels = "%b %e, %Y"
  ) +
  theme_bw() +
  theme(
    plot.title   = element_text(size = 30, family = "serif"),
    axis.title   = element_text(size = 20, family = "serif"),
    axis.text    = element_text(size = 14, family = "serif"),
    plot.caption = element_text(size = 14, family = "serif"),
  ) +
  labs(
    title   = "The rate at which you post on Instagram has more than doubled over time",
    x       = "Date",
    y       = "Cumulative Number of Instagram Posts",
    caption = "Data Source: The Rinstapkg package
      (available at: https://github.com/eric88tchong/Rinstapkg)"
  )

ggsave(
  filename = here("10_group-project-prep", "outputs", today(), "figure-1.pdf"),
  width    = 13.33,
  height   = 7.5,
  units    = "in"
)  

tjl_instagram %>% 
  ggplot(aes(x = timestamp, y = like_count)) +
  geom_smooth() +
  coord_cartesian(ylim = c(0, 200)) +
  scale_x_datetime(
    date_breaks = "1 year",
    date_labels = "%b %e, %Y"
  ) +
  theme(
    axis.title = element_text(size = 18, family = "Serif"),
    plot.title = element_text(size = 24)
  ) +
  labs(
    title = "The Juice Laundry's Instagram Posts Were Increasing in Popularity Until Recently",
    x = "Date",
    y = "Average Number of Likes"
  )

# miscellaneous analyses -----------------------------------------------------
# tally the posts by location and sort them from most to least frequently used
tjl_instagram %>% 
  count(location, sort = TRUE)

# filter for posts within the time period of the juicelaundry package
tjl_instagram %>% 
  filter(
    between(
      x = timestamp, 
      left  = as.POSIXct("2016-10-11"), 
      right = as.POSIXct("2018-12-31")
    )
  )