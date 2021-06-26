# FinanciaLitycs #

# libs
library(tidyverse)
library(lubridate)
library(janitor)

# config desk 
setwd("C:/Users/andre/Downloads")


# All records from 01-01-2021 to 19-03-2021 #


checking_account <- openxlsx::read.xlsx("checking_2021.xlsx") %>% as_tibble()
amex_ccard <- openxlsx::read.xlsx("amex_2021.xlsx") %>% as_tibble()
visa_ccard <- openxlsx::read.xlsx("visa_2021.xlsx") %>% as_tibble() 
mcard_ccard <- openxlsx::read.xlsx("mcard_2021.xlsx") %>% as_tibble()  

setwd("~/MQF-UAH")

checking <- checking_account  %>% 
   select(-DOCUMENTO,-OFICINA) %>% rename(date = FECHA,
                                          desc = DESCRIPCIÓN,
                                          ref  = REFERENCIA,
                                          amount = VALOR) %>% 
   mutate(date = as.Date(date, origin = "1899-12-30")) %>% 
   mutate(type = ifelse(amount<0, "expense","payment")) %>% 
   mutate(month = substr(date,6,7))
   

   
amex <- amex_ccard  %>% 
   select(-PLAZO,-MONEDA,-FECHA_FACTURACIÓN) %>% 
   rename(date = FECHA, desc = DESCRIPCIÓN,amount = VALOR) %>%   
   mutate(date = as.Date(date, origin = "1899-12-30")) %>% 
   mutate(type = ifelse(amount<0, "payment","expense")) %>% 
   mutate(instrument = "amex")


visa <- visa_ccard  %>% 
   select(-PLAZO,-MONEDA,-FECHA_FACTURACIÓN) %>% 
   rename(date = FECHA, desc = DESCRIPCIÓN,amount = VALOR) %>% 
   mutate(date = as.Date(date, origin = "1899-12-30")) %>% 
   mutate(type = ifelse(amount<0, "payment","expense")) %>% 
   mutate(instrument = "visa")


mcard <- mcard_ccard %>% 
   select(-PLAZO,-MONEDA,-FECHA_FACTURACIÓN) %>% 
   rename(date = FECHA, desc = DESCRIPCIÓN, amount = VALOR) %>% 
   mutate(date = as.Date(date, origin = "1899-12-30")) %>% 
   mutate(type = ifelse(amount<0, "payment","expense")) %>% 
   mutate(instrument = "mcard")


dprods <- amex %>% bind_rows(visa, mcard) %>% 
   mutate(month = substr(date,6,7)) %>% distinct()


dprod_summary <- dprods %>%
   group_by(month,desc,type,instrument) %>%
   summarise(n = n(), amount = sum(amount), .groups = "drop") %>% 
   arrange(month)

qt_summary <- dprod_summary %>%
   group_by(desc) %>% summarise( amount = sum(amount))%>%
   filter(!grepl("ABONO",desc))


avoidable <- c("UBER|RESTAUR|BEAT|DOLLAR|AVANC|ALKO|CHAMP|MALL|PORTO|CRISTIN|RAPPI|KOMOD|IC")
fat_food <- c("RESTAUR|DOLLAR|MALL|CRISTIN|RAPPI|KOMOD")


essens <- qt_summary %>% filter(!grepl(paste(avoidable),desc))
not_essens <- qt_summary %>% filter(grepl(paste(avoidable),desc))
fatness <- qt_summary %>% filter(grepl(paste(fat_food),desc)) %>% filter(!grepl("SUPERM",desc))


income <- checking %>% filter(type == "payment", amount>10) %>% filter(!grepl("NEQUI|TC",desc))


# Charting 

amex_grouped <- dprods %>%
   filter(month == "03", instrument == "amex") %>% 
   group_by(date) %>%
   summarise(amount=sum(amount)) %>% ungroup() %>% 
   filter(amount>10)
ggplotly(ggplot(amex_grouped, aes(x=date,y=amount))+geom_line())


amex_paid <- dprods %>%
   filter(month == "03", instrument == "amex") %>% 
   group_by(date) %>%
   summarise(amount=sum(amount)) %>% ungroup() %>% 
   filter(amount<10) %>%
   mutate(amount =abs(amount))
ggplotly(ggplot(amex_paid, aes(x=date,y=amount))+geom_line())



expensed <- dprods %>% group_by(date) %>% 
   summarise(amount = sum(amount)) %>% 
   filter(amount>0)%>%
   mutate(perce = amount/sum(amount)) %>% 
   mutate(perce = scales::percent(perce)) %>% 
   mutate(month = substr(date,6,7))


plotly::ggplotly(ggplot(expensed, aes(x=date,y=amount))
         +geom_line()) 

paid <- dprods %>% group_by(date) %>% 
   summarise(amount = sum(amount)) %>% 
   filter(amount<0) %>% 
   mutate(amount = abs(amount))%>% 
   mutate(perce = amount/sum(amount)) %>% 
   mutate(perce = scales::percent(perce))

plotly::ggplotly(ggplot(paid, aes(x=date,y=amount))
         +geom_line()) 


expensed_grouped <- dprods %>% 
   filter(month == "03") %>% 
   filter(amount >0,!grepl("AVANCE",desc)) %>% 
   group_by(desc) %>% 
   summarise(amount = sum(amount))


# Monthly P&L

# Month income ::: 
inc <- checking %>% filter(amount>10, month == "03") %>% filter(!grepl("TC",desc))
income_03 <- sum(inc$amount)

# Mont exhpe ::: 

outcome_03 <- sum(expensed_grouped$amount)
clean_out_03 <- expensed_grouped %>% 
   filter(!grepl("CHAMP|RAPPI|RESTAURANT|TAJAMA|KOMOD",desc))

impulses_records <-  expensed_grouped %>% 
   filter(grepl("CHAMP|RAPPI|RESTAURANT|TAJAMA|KOMOD",desc)) %>% 
   mutate(type = ifelse(desc =="CHAMPS OUTLET N 3","lux","fat"))


clean_outcome_03 <- sum(clean_out_03$amount)

# Ratio & Diff
outcome_03/income_03
income_03 - outcome_03

# If saved
clean_outcome_03/income_03
income_03-clean_outcome_03

# Impulses expenses 
(income_03-clean_outcome_03) - (income_03 - outcome_03)



# Cash Position on April 2nd ::: 

# Income Sources ::: 

rohos   <- 2000000
saved   <- 520000
ctrader <- 730
trm     <- 3550
extra   <- 24000

# Total IN
income = rohos + saved + (ctrader * trm) + (extra * 8)


# Fix Expenses :::

rina  <- 300000
water <- 150000
light <- 450000
movistar <- 90000

# FIXEX
fix_expense= rina+water+light+movistar
   
# Variable Expenses :::

ctrader_depo <- 1830000
total_expense= fix_expense + ctrader_depo

# Cash 

cash <- income - total_expense



exe <- function(pl){ 
v <- 1889000
a <- 5878000
trm <- 3800


D <- v+a
I <- trm*pl

R <- D-I

RRP <- R/1500000
RRM <- R/3500000

return(list(D,I,R, RRP,RRM))

}

library(tidyverse)
setwd("C:/Users/andre/Downloads")

pb <- openxlsx::read.xlsx("pb.xlsx")

mb <- pb %>% 
   mutate(date = as.Date(date, origin = "1899-12-30")) %>% 
   mutate(ym = substr(date,0,7)) %>% 
   group_by(ym) %>%
   summarise_if(is.numeric, sum) %>% 
   select(-R) %>% 
   ungroup() %>% 
   mutate(fp = income-light-water-movist-school-amx-vsa-mcard-c1-c2) %>% 
   rowwise() %>% 
   mutate(fixE = sum(light+water+school+movist),
          fixF = sum(c1,c2),
          varF = sum(amx,vsa,mcard)) %>% 
   janitor::adorn_totals()

# Rowwise by period Mayus and diff vs inc

mb %>% select(ym,income,fixE,fixF,varF) %>% 
   rowwise() %>% mutate(all_out = sum(fixE,fixF,varF)) %>% 
   mutate(result = income-all_out)
