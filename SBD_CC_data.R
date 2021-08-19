

# DA Actuals automation; 
# source ::: SAP KSB1 report from instance c11 


library(tidyverse)
library(lubridate)
library(zoo)


getwd()
setwd("C:/Users/andre/Downloads")


da_close <- function(){ 

# cost_centers_data.   
ccdata <- openxlsx::read.xlsx("datacc.xlsx") %>% as_tibble() %>% 
   janitor::clean_names()


# fix_assets 
clearing <- ccdata %>% filter(grepl("FIXED ASSETS - C.I.P.",name_of_offsetting_account)) %>% 
   select(cost_element, cost_element_name, period,val_in_rep_cur) %>% 
   rename(clearing_account = val_in_rep_cur) %>% distinct()
   

# tidy_actuals.
actuals <- ccdata %>% 
   filter(!cost_element %in% c("1817400","1919350","5672215")) %>% 
   group_by(cost_element,cost_element_name, period) %>% 
   summarise(val_in_rep_cur = sum(val_in_rep_cur), .groups = "drop") %>% 
   left_join(clearing, by = c("cost_element","cost_element_name", "period")) %>% 
   ungroup() %>% 
   replace_na(list(val_in_rep_cur = 0, clearing_account = 0)) %>% 
   mutate(period = as.numeric(period)) %>% 
   mutate(date = make_date(year = year(today()),
                           month = period, day = 1L)) %>%
   mutate(period = as.yearmon(date)) %>%
   select(-date) %>% 
   rename(actual = val_in_rep_cur) %>% 
   mutate(gross = actual - clearing_account) %>% 
   mutate(category =case_when(str_detect(cost_element_name,"EMP BEN")~"C&B",
                              str_detect(cost_element_name,"PR TAXE")~"C&B",
                              str_detect(cost_element_name,"WAGE")~"C&B",
                              str_detect(cost_element_name,"DEMO")~"Demo Tools",
                              str_detect(cost_element_name,"OS FEE LABOR")~"Globant Profesional Fees",
                              str_detect(cost_element_name,"PROMO SPECIAL P")~"Promo Services",
                              str_detect(cost_element_name,"OS FEE RECRUIT")~"Recruitment",
                              str_detect(cost_element_name,"RENT BUILD")~"Recruiting",
                              str_detect(cost_element_name,"AMORTIZ SOFTW")~"Software Amortization",
                              str_detect(cost_element_name,"MATL PROTO")~"Supplies & Other",
                              str_detect(cost_element_name,"OS FEE LEGAL GEN")~"Supplies & Other",
                              str_detect(cost_element_name,"OTH EXP MISC")~"Supplies & Other",
                              str_detect(cost_element_name,"SUPPLIES")~"Supplies & Other",
                              str_detect(cost_element_name,"T&E")~"T&E",
                              str_detect(cost_element_name,"UTILITY TELEP")~"Telephone",
                              str_detect(cost_element_name,"EMP DEV SHOW EXHIBIT")~"Supplies & Other",
                              TRUE ~ as.character(cost_element_name))) %>% 
   relocate(.before = cost_element, category )%>% 
   replace(.,is.na(.),0)
   

   
# wider table with actuals. 
report <- actuals %>%  
   pivot_wider(names_from = period, values_from = c(actual,
                                                    clearing_account,
                                                    gross)) %>% 
   janitor::clean_names() %>% 
   select(category,cost_element,cost_element_name,
          actual_jan_2021, clearing_account_jan_2021,gross_jan_2021,
          actual_feb_2021, clearing_account_feb_2021,gross_feb_2021,
          actual_mar_2021, clearing_account_mar_2021,gross_mar_2021,
          actual_apr_2021, clearing_account_apr_2021,gross_apr_2021,
          actual_may_2021, clearing_account_may_2021,gross_may_2021,
          actual_jun_2021, clearing_account_jun_2021,gross_jun_2021,
          actual_jul_2021, clearing_account_jul_2021,gross_jul_2021
   )



# summarized actuals by category. 
resumen_actuals <-  actuals %>% 
   group_by(category, period) %>%
   summarise(gross = sum(gross),.groups="drop") %>% 
   pivot_wider(names_from = period, values_from = gross) %>% 
   replace(.,is.na(.),0) %>% 
   # janitor::adorn_totals() %>% 
   mutate(type = "gross") %>% 
   relocate(.before = category, type)


# summarized capitalization. 
resumen_capitalized <-  actuals %>% 
   group_by(category, period) %>%
   summarise(clearing_account = sum(clearing_account),.groups="drop") %>% 
   pivot_wider(names_from = period, values_from = clearing_account) %>% 
   replace(.,is.na(.),0) %>% 
   # janitor::adorn_totals() %>% 
   mutate(type = "adjustement") %>% 
   relocate(.before = category, type)


resumen <- resumen_actuals %>% bind_rows(resumen_capitalized) %>% 
   janitor::adorn_totals()


return(list(raw_cc = ccdata, fixed_assets = clearing,
            tidy_actuals= actuals, report = report,
            summary = resumen))


}

da_close() %>% openxlsx::write.xlsx(.,"report_da.xlsx")


   