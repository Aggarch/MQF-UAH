
# pptx automation
# https://ljupcho.com/blog/powerpoint

# libs

library(officer)
library(flextable)
library(tidyverse)
library(tidyquant)
library(timetk)


# Data
# ALLE : Allegion PLC 
# 

stock_data <- c("FTV","ALLE","GOOG","SWK") %>% 
   tq_get()


# Wrangling
stock_ret_tbl <- stock_data %>% 
   select(symbol, date, adjusted) %>% 
   group_by(symbol) %>% 
   summarise(
      week = last(adjusted)/first(tail(adjusted,7)) - 1,
      month= last(adjusted)/first(tail(adjusted,30))- 1,
      quarter= last(adjusted)/first(tail(adjusted,90))-1,
      year= last(adjusted)/(first(adjusted,365))-1,
      all= last(adjusted)/(first(adjusted))-1
   )



# plot 
stock_plot <- stock_data %>% 
   group_by(symbol) %>% 
   summarise_by_time(date,adjusted = AVERAGE(adjusted), .by = "week") %>% 
   plot_time_series(date, adjusted, .facet_ncol = 2, .interactive = F)

stock_plot


# stock table
stock_tbl <- stock_ret_tbl %>% 
   rename_all(.funs = str_to_sentence) %>% 
   mutate_if(is.numeric, .funs = scales::percent) %>% 
   flextable::flextable()


stock_tbl


# pptx deck 

doc <- read_pptx()
doc <- add_slide(doc)
doc <- ph_with(doc, value = "stock report", location = ph_location_type(type = "title"))
doc <- ph_with(doc, value = stock_tbl, location = ph_location_left())
doc <- ph_with(doc, value = stock_plot, location = ph_location_right())

print(doc, target = "SBD_minimalistic_example_auto.pptx")
   









