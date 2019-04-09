#' ---
#' title: "Communication"
#' author: 
#' date: 
#' output: github_document
#' ---

library(tidyverse)
library(ggrepel)
library(viridis)
library(juicelaundry)
library(completejourney)
library(lubridate)
library(here)

options(warnPartialMatchArgs = FALSE)

#' Let's start by making `campaign_descriptions` long.

campaign_descriptions %>% 
   gather(start_date, end_date, key = campaign_event, value = date) -> 
   # pivot_longer(
   #    cols = start_date:end_date,
   #    names_to = "campaign_event",
   #    values_to = "date"
   # ) ->
   campaign_descriptions_long

# let's get to know the related tables
coupons %>% 
   left_join(campaign_descriptions) %>% 
   ggplot(aes(x = campaign_id, fill = campaign_type)) +
   geom_bar()

campaigns %>% 
   left_join(campaign_descriptions) %>% 
   ggplot(aes(x = campaign_id, fill = campaign_type)) +
   geom_bar()

#' From the documentation, it isn't clear what the difference is between
#' `campaign_type == "Type B"` and `campaign_type == "Type C"`. Let's collapse
#' these campaign types and create new distinctions.

campaign_descriptions_long %>% 
   mutate(
      campaign_type = fct_collapse(campaign_type,
         "Purchase History" = c("Type A"),
         "Regular"          = c("Type B", "Type C")
      )
   ) ->
   campaign_descriptions_long

campaign_descriptions_long %>% 
   ggplot(aes(x = date, y = campaign_id %>% fct_reorder(date, .fun = "min"))) + 
   # add reference lines for the start and end of the study period
   # Hadley and Garrett make three recommendations: "make them thick (size = 2)
   # and white (colour = white), and draw them underneath the primary data
   # layer. That makes them easy to see, without drawing attention away from the
   # data."
   geom_vline(xintercept = as.Date("2017-01-01"), size = 2, colour = "white") +
   geom_vline(xintercept = as.Date("2018-01-01"), size = 2, colour = "white") +
   
   geom_line(aes(group = campaign_id), size = 1.5, colour = "grey50") + 
   geom_point(aes(colour = campaign_type), size = 4) +
   scale_x_date(
      # breaks = seq.Date(
      #    from = date("2016-11-01"), 
      #    to   = date("2018-03-01"), 
      #    by   = "1 month"
      # ),
      date_breaks = "month", 
      date_labels = "%b %e, %Y"
   ) +
   # theme() settings control non-data parts of a plot
   theme(
      legend.position = "bottom", 
      axis.text.x = element_text(angle = 45, hjust = 1)
   ) +
   guides(colour = guide_legend(override.aes = list(size = 4))) +
   labs(
      title = "The completejourney Package Includes Delivery and Redemption Data for 27 Distinct Coupon Campaigns",
      subtitle = "These campaigns spanned the one-year study period and a campaign based on the households' purchase history was executed each quarter",
      x = "Date",
      y = "Campaign ID",
      color = "Campaign Type",
      caption = "Data Source: The completejourney package 
      (available at: https://github.com/bradleyboehmke/completejourney)"
   )

dir.create(
   path = here("09_communication", "scripts", "output", today())
)

ggsave(
   filename = 
      here("09_communication", "scripts", "output", today(), "figure-1.pdf"),
   plot = last_plot(),
   width = 13.33,
   height = 7.5,
   units = "in"
)

# create data summaries for the expository plot ---------------------------

campaign_descriptions_long %>% 
   group_by(campaign_id) %>% 
   mutate(campaign_length = date - lag(date)) %>% 
   group_by(campaign_type) %>% 
   summarize(
      campaign_length_ave = mean(campaign_length, na.rm = TRUE) %>% round(0)
   ) %>% 
   arrange(campaign_length_ave)

campaign_descriptions_long %>% 
   select(campaign_id, campaign_type) %>% 
   distinct() %>% 
   count(campaign_type)