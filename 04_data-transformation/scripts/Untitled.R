transaction %>% 
  mutate(
    net_sales = price_charged - fee_owed - refund_given - tax_collected
  )

# filter down to a useable transaction table


transaction %>% 
  left_join(location, by = "location_id") %>% 
  select(transaction_id:timestamp, location_name) %>%
  filter(
    location_name %in% c("Preston Ave. (C'ville)", "The Corner (C'ville)",
                         "The Yards (DC)"),
    
  )
 
