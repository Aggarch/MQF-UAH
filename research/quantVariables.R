#### Quant  AG : Master in Quantitative Finance ####

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ----

# Infrastructure :  tidyquant {timetk, xts, zoo, Qunatmod, TTR, PerformanceAnalytics}
# Data Sources :::  FRED, Bloomberg, Quandl, Morningstar, Yahoo Finance
# Data Since   :::  2010-01-01 {After Sub-prime cicle, to reduce RV}
# Mark to Market ::: https://www.cmegroup.com/education/courses/introduction-to-futures/mark-to-market.html

# Vignettes :::

# browseVignettes(package = "tidyquant")
# browseVignettes(package = "timetk")


# Libraries activate the packs, please do install.packages() before continue.

library(tidyverse)
library(tidyquant)
library(timetk)
library(corrplot)
library(alphavantager)
library(plotly)

# Thesis: Data treatment philosophy:
# 1.)   Tidy - Data: ####
# makes reference to the macroeconomic data and treasury rates in a tidy format: 
# Data tidyng phiosophy: Each Column represents a variable, each row show the values.
#browseURL("https://vita.had.co.nz/papers/tidy-data.pdf")

# Displpay some tidyquant options :::

tq_mutate_fun_options()
tq_performance_fun_options()
# ... ----

# 2.) MACROECONOMICS & PRIMES ####
# Macroeconomics: 

# Code may be optimize, however I prefer to indicate it step by step

# One by Variable:

# GDP per capita is gross domestic product divided by population.
# GDP is the sum of gross value added by all resident
# producers in the economy plus any product taxes and minus any
# subsidies not included in the value of the products. It is calculated
# without making deductions for depreciation of fabricated assets or for
# depletion and degradation of natural resources.
# World Bank national accounts data, and OECD National Accounts data files.

# # It's easier to make only one call to the data using the tq_get(), however for clarification 
# # purposes, we prefer to create one object by each variable. : 

# Like : 
# Market <- tq_get(c("DTWEXM", "DEXJPUS", "DEXCAUS", "DEXUSAL",
#                    "DEXUSUK", "DEXUSEU", "DGS10", "FEDFUNDS", "DCOILWTICO", 
#                    "GOLDAMGBD228NLBM","DJIA","SP500"),
#                  get = "economic.data", from = "2006-01-01") %>% 
#   filter(year(date) >=  "2010-01-01") %>% 
#   pivot_wider(names_from = symbol, values_from = price) %>% 
#   na.locf() %>% 
#   rename(DXY_CUR = DTWEXM) 



# GDP stands for "Gross Domestic Product" and represents the total monetary value of all final goods and services
# produced (and sold on the market) tthis index make reference to the Gobal market.
Global_GDP <- tq_get("NYGDPPCAPKDWLD", get = "economic.data", from = "2017-01-01")

# Economic Policy Uncertainty Index: EPU
#browseURL("http://www.policyuncertainty.com/media/BakerBloomDavis.pdf")
Economic_Policy_Risk <- tq_get("USEPUINDXD", get = "economic.data", from = "2017-01-01")

# Global Economic Policy Uncertainty: 
#browseURL("https://www.nber.org/papers/w22740")
Global_Economic_Uncertainty <- tq_get("GEPUPPP", get = "economic.data", from = "2010-01-01")

# Trade Policy uncertainty Index
#browseURL("https://www.policyuncertainty.com/china_monthly.html")
Trade_Policy_Risk <- tq_get("CHNMAINLANDTPU", get = "economic.data", from = "2010-01-01")

# Monthly Supplpy of Houses: 
Houses_Month_supply <- tq_get("MSACSR", get = "economic.data", from = "2010-01-01") 

# Consumer price Index - Inflation measure
CPI <- tq_get("CPIAUCSL", get = "economic.data", from = "2010-01-01", to = Sys.Date())

# Real Gross Domestic Prduct for US
Real_GDP <- tq_get("A191RL1Q225SBEA", get = "economic.data", from = "2010-01-01")

# Industrial Production Index
IPI <- tq_get("INDPRO", get = "economic.data", from = "2010-01-01") 

# Non-Farm Payrrols / Employment Measure
Non_Farm_Payrolls <- tq_get("PAYEMS", get = "economic.data", from = "2010-01-01")

# Unemployment Rate
Unemployment_Rate <- tq_get("UNRATE", get = "economic.data", from = "2010-01-01")
      
# US Treasury 10 Years
Treasury_10y <- tq_get("DGS10", get = "economic.data", from = "2010-01-01")

# US Treasury 2 Years 
Treasury_2y <-  tq_get("GS2", get = "economic.data", from = "2010-01-01")

# Reference interest Rates / setted by Central Bank> 
FED_Interest_Rate <- tq_get("FEDFUNDS", get = "economic.data", from = "2010-01-01")


# A ggplot of the Global Economic Policy Uncertainty : 
Economic_policy_index <- 
  ggplotly(
    Economic_Policy_Risk %>%
      filter(date >= "2019-10-20") %>% 
      ggplot(aes(x = date, y = price))+
      theme_tq()+
      geom_point(color = "steelblue", size = 2)+
      geom_line(color = "gray", size = 1)+
      geom_smooth(color = "orange", method = loess)+
      labs(x = "Date", y = "Economic Policy Uncertainty Index",
           title = "Global Economic Policy Uncertainty Evolution")
  )

# 2.1) Tidy tibble of Macro & Primes  ####
Macro_primes <- 
  bind_rows("Economic_Policy_Risk" = Economic_Policy_Risk,
            "Global_Uncertainty" = Global_Economic_Uncertainty,
            "Trade_Policy_Risk" = Trade_Policy_Risk,
            "CPI" = CPI,
            "Houses_Month_supply" = Houses_Month_supply,
            "IPI" = IPI, 
            "Non_Farm_Payrolls" = Non_Farm_Payrolls,
            "Unemployment_Rate" = Unemployment_Rate,
            "Treasury_10y" = Treasury_10y, 
            "Treasury_2y" = Treasury_2y, .id = "commodity_name")
Macro_primes

# 2.2) Correlation Macro & Primes  ####
# This correlation can be calculated after the data spread and matrix building 
Macros_Primes_corr <- 
  Macro_primes %>% 
  pivot_wider(names_from = commodity_name,values_from = price) %>% 
  na.locf() %>% 
  select(-date) %>% 
  cor() 
Macros_Primes_corr

# Correlation matrix ploted 
Macros_Primes_Corrplot <- 
  corrplot(Macros_Primes_corr, method = "shade" ,
           addCoef.col = "gray", 
           tl.col = "darkblue",
           order = "hclust",)
Macros_Primes_Corrplot

# Corrplot looks good at 80$ zoom

# ... ----

# 3.)  INDEXES ####

# 3.1) Composition of Indexes ####
SP500 <- tq_index("SP500")
DJI <- tq_index("DOW")


# 3.2)  Sectors Pareto ####
SP500_sectors <- 
  SP500 %>% 
  group_by(sector) %>%
  summarise(weight2 = sum(weight)) %>%
  arrange(desc(weight2)) %>% 
  mutate(Pareto = cumsum(weight2))

DJI_sectors <- 
  DJI %>%
  mutate(pareto = cumsum(weight)) %>%
  group_by(sector) %>%
  summarise(weight2 = sum(weight)) %>%
  arrange(desc(weight2)) %>%
  mutate(cumulat = cumsum(weight2))

# NASDAQ Inside ::.
# NDAQ <- tq_exchange("NASDAQ")
# 
# NDAQ_sectors <- 
#   NSDAQ%>%
#   group_by(sector) %>%
#   summarise(n = n() , Mcap2 = cumsum(market.cap)/sum(market.cap)) %>%
#   arrange(desc(Mcap2))

# 3.3) Historic of Indexes ####
SP500   <- tq_get("SP500", get = "economic.data", from = "2010-01-01" )
DOW     <- tq_get("DJIA", get = "economic.data", from = "2010-01-01" )
NASDAQ  <- tq_get("NASDAQCOM", get = "economic.data", from = "2010-01-01")
NIKKEI  <- tq_get("NIKKEI225", get = "economic.data", from = "2010-01-01" )  
VIX     <- tq_get("VIXCLS", get = "economic.data", from = "2010-01-01" )
DXY_CUR <- tq_get("DTWEXM", get = "economic.data",from = "2010-01-01") 


# 3.4) Tidy tibble of Indexes ####
Indexes <- bind_rows("DOW" = DOW, "SP500" = SP500,
                     "NDAQ" = NASDAQ, "NIKKEI" = NIKKEI,
                     "VIX" = VIX, "DXY" = DXY_CUR, .id = "Indexes")

Indexes <- bind_rows("DOW" = DOW, "SP500" = SP500,
                     "NDAQ" = NASDAQ, "NIKKEI" = NIKKEI,
                     "VIX" = VIX, "Economic_Policy_Risk" = Economic_Policy_Risk,
                     .id = "Indexes")

Indexes <- bind_rows("DOW" = DOW, "SP500" = SP500,
                     "NDAQ"= NASDAQ, "NIKKEI" = NIKKEI,
                     "VIX" = VIX, "EPU" = Economic_Policy_Risk,
                     "DXY" = DXY_CUR,
                     .id = "Indexes")

Indexes

# 3.5) Correlation of Indexes ####
# We can observe that the correlation between the positive returns of stocks against volatility its negative  
# It drives us to dive into the relationship between Risk & Return 

Indexes %>% 
  pivot_wider(names_from = Indexes, values_from = price) %>% 
  select(-date,-symbol) %>%  
  na.omit() %>% 
  cor() -> index_cor

corrplot(index_cor)

Index_Corrplot <- 
  corrplot(index_cor, method = "square",
           addCoef.col = "gray", 
           tl.col = "darkblue",
           order = "hclust")

# Whats the Mean correlation of this heatmap,
# It may be interesting to plot it as the intercept of a rolling corr. 
DXY_mean_cor <- mean(index_cor [,7:7])

# 3.6) Rolling Correlation ####

# 1) Calculate returns: (daily)
Index_daily_returns <- Indexes %>% 
  group_by(Indexes) %>% 
  tq_transmute(select = price,
               mutate_fun = periodReturn,
               period = "daily")%>% 
  filter(date >= "2019-09-15")

# 2) Baseline
baseline_returns_daily <- "DTWEXM" %>%
  tq_get(get  = "economic.data",
         from = "2019-09-15",
         to   = Sys.Date()) %>%
  tq_transmute(select     = price,
               mutate_fun = periodReturn,
               period     = "daily")

returns_joined <- left_join(Index_daily_returns,
                            baseline_returns_daily,
                            by = "date") %>% na.omit

# 3) Calculate the correlation. 
Index_rolling_corr <- returns_joined %>%
  tq_transmute_xy(x          = daily.returns.x,
                  y          = daily.returns.y,
                  mutate_fun = runCor,
                  n          = 6,
                  col_rename = "rolling.corr")

ggplotly( 
  Index_rolling_corr %>%
    filter(Indexes != "DXY") %>% 
    ggplot(aes(x = date, y = rolling.corr, color = Indexes)) +
    geom_hline(yintercept = c(DXY_mean_cor, 0), color = palette_light()[[8]]) +
    geom_line(size = 1.5) +
    labs(title = "Rolling Correlation to DXY",
         x = "", y = "Correlation", color = "") +
    facet_wrap(~ Indexes, ncol = 2) +
    theme_tq() +
    scale_color_tq()
)

# ... ----

# 4.)  STOCKS ####
AAPL  <- tq_get("AAPL", get = "stock.prices", from = "2010-01-01")
GOOG  <- tq_get("GOOG", get = "stock.prices", from = "2010-01-01")
MSFT  <- tq_get("MSFT", get = "stock.prices", from = "2010-01-01")
AMZN  <- tq_get("AMZN", get = "stock.prices", from = "2010-01-01")
FB  <- tq_get("FB", get = "stock.prices", from = "2010-01-01")
TWTR  <- tq_get("TWTR", get = "stock.prices", from = "2010-01-01")


# 4.1.1) Charting 

AAPL %>%
  ggplot(aes(x = date, y = close, open = open,
             high = high, low = low, close = close)) +
  geom_candlestick() +
  geom_bbands(ma_fun = SMA, sd = 2, n = 20, 
              linetype = 4, size = 1, alpha = 0.2, 
              fill        = palette_light()[[1]], 
              color_bands = palette_light()[[1]], 
              color_ma    = palette_light()[[2]]) +
  labs(title = paste0(input$variable, "Candlestick Chart"), 
       subtitle = "BBands with SMA Applied, Experimenting with Formatting", 
       y = "Closing Price", x = "") + 
  theme_tq()


# 4.1) Tidy tibble of Stocks ####
Stocks <- bind_rows("AAPL" = AAPL, "GOOG" = GOOG, "MSFT" = MSFT,
                    "AMZN" = AMZN, "FB" = FB, "TWTR" = TWTR, .id = "id") 

# 4.2) Monthly price ####
Stocks %>% 
  group_by(id) %>% 
  tq_transmute(select = close, 
               mutate_fun = to.monthly,
               indexAt = "lastof")

# 4.3) Rollapply: ####
# Calculate returns 
Returns <- 
  Stocks %>% 
  group_by(id) %>% 
  tq_transmute(adjusted, 
               periodReturn, period = "weekly", 
               col_rename = "Returns")

apple_returns <- 
  AAPL %>% 
  tq_transmute(adjusted,
               periodReturn, period = "weekly",
               col_rename = "APPLE.returns")

fb_returns <- 
  FB %>% 
  tq_transmute(adjusted,
               periodReturn, period = "weekly",
               col_rename = "FB.returns")

# To blend returns or combine them calculate indicidually a join them.
blend_returns <- left_join(fb_returns, apple_returns, by = "date")

# Apply custom function
regr_fun <- function(data) {
  coef(lm(FB.returns ~ APPLE.returns, data = timetk::tk_tbl(data, silent = TRUE)))
}

# ... ---- 

# 5.) Rolling regression with rollapply ####
# Apply the custom function. 

blend_returns %>%
  tq_mutate(mutate_fun = rollapply,
            width      = 12,
            FUN        = regr_fun,
            by.column  = FALSE,
            col_rename = c("coef.0", "coef.1"))

# ... ----   

# 6.)  COMMODITIES ####

# Set category id for Oil and Gold.
WTI      <- tq_get("WTISPLC", get = "economic.data", from = "2010-01-01" )
Brent    <- tq_get("POILBREUSDM", get = "economic.data", from = "2010-01-01")
Gold     <- tq_get("GOLDAMGBD228NLBM", get = "economic.data", from = "2010-01-01")
Aluminum <- tq_get("PALUMUSDM", get = "economic.data", from = "2010-01-01")
#Copper   <- tq_get("PCOPPUSDM", get = "economic.data", from = "2010-01-01")
Corn     <- tq_get("PMAIZMTUSDM", get = "economic.data", from = "2010-01-01") 
Soy      <- tq_get("PSOYBUSDQ", get = "economic.data", from = "2010-01-01")

# 6.1) Tidy tibble of Commodities ####
Commodities <- 
  bind_rows("WTI" = WTI, "Brent" = Brent,
            "Gold" = Gold, "Aluminum" = Aluminum, 
            "Corn" = Corn, "Soy" = Soy,
            .id = "commodity_name")
Commodities


# 6.2) Commodities Correlation ####
Commodities_cor <- 
  Commodities %>% 
  pivot_wider(names_from = commodity_name,values_from = price) %>% 
  na.locf() %>% 
  select(-date) %>% 
  cor() 
Commodities_cor

#Quaterly
Commodities_Corrplot <- 
  corrplot(Commodities_cor, method = "square",
           addCoef.col = "gray", 
           tl.col = "darkblue",
           order = "hclust")
Commodities_Corrplot

# ... ----

# 7.) CURRENCIES ####
# Pricipal currencies in the world:
# browseURL("https://www.investopedia.com/trading/most-tradable-currencies/")
# Dollar Basket:
# browseURL("https://www.bloomberg.com/quote/DXY:CUR")

#Dollar Basket:
# DXY_CUR <- tq_get("DTWEXM", get = "economic.data",from = "2010-01-01")  


DXY_CUR <- tq_get("DTWEXAFEGS", get = "economic.data",from = "2010-01-01") 
EUR_USD <- tq_get("DEXUSEU", get = "economic.data", from = "2010-01-01")
GBP_USD <- tq_get("DEXUSUK", get = "economic.data", from = "2010-01-01")
USD_JPY <- tq_get("DEXJPUS", get = "economic.data", from = "2010-01-01")
USD_CAD <- tq_get("DEXCAUS", get = "economic.data", from = "2010-01-01")
AUD_USD <- tq_get("DEXUSAL", get = "economic.data", from = "2010-01-01")
USD_CHF <- tq_get("DEXSZUS", get = "economic.data", from = "2010-01-01")
USD_SEK <- tq_get("DEXSDUS", get = "economic.data", from = "2010-01-01")

# Primes are upside in Macroeconomics 

FX  <- bind_rows("DXY:CUR" = DXY_CUR,
                 "EUR/USD" = EUR_USD,  "GBP/USD" = GBP_USD,
                 "USD/JPY" = USD_JPY,  "USD/CAD" = USD_CAD,
                 "AUD/USD" = AUD_USD,  "USD/CHF" = USD_CHF,
                 "USD/SEK" = USD_SEK, .id = "currency")

FX

# 7.1) Tidy tibble of Fx + primes ####
FX_primes <- bind_rows("DXY:CUR" = DXY_CUR, 
                       "EUR/USD" = EUR_USD,  "GBP/USD" = GBP_USD,
                       "USD/JPY" = USD_JPY,  "USD/CAD" = USD_CAD,
                       "AUD/USD" = AUD_USD,  "USD/CHF" = USD_CHF,
                       "ZAR/USD"=ZAR_USD, "FED_Interest_Rate" = FED_Interest_Rate, 
                       "Treasury_10y" = Treasury_10y, "Treasury_2y" = Treasury_10y,
                       .id = "currency") 
FX_primes

# 7.2) Correlate the F Exchange ####
FX_primes_cor <- 
  FX_primes %>% 
  pivot_wider(names_from = currency, values_from = price) %>% 
  select(-date) %>% 
  na.omit() %>% 
  cor() 


FX_Primes_Corrplot <- 
  corrplot(FX_primes_cor, method = "square",
           addCoef.col = "gray", 
           tl.col = "darkblue",
           order = "hclust")

# ... ----

# 8) DATA LAKE TABLE xlsx ####
# Data lost cause bind_rows step, 
# Full Data coverage, do data frames really affect the result ?  

# FX <- 
# DXY_CUR %>% 
#        left_join(EUR_USD, by = c("date" = "date")) %>% 
#             left_join(GBP_USD, by = c("date" = "date")) %>% 
#                left_join(USD_JPY, by = c("date" = "date")) %>% 
#                    left_join(USD_CAD, by = c("date" = "date")) %>% 
#                        left_join(AUD_USD, by = c("date" = "date")) %>% 
#                           left_join(USD_CHF, by = c("date" = "date")) %>% 
#                              left_join(ZAR_USD, by = c("date" = "date")) %>%                          
#   
#        rename(DXY_CUR = price.x, EUR_USD = price.y, GBP_USD = price.x.x, USD_JPY = price.y.y,
#               USD_CAD = price.x.x.x, AUD_USD = price.y.y.y, USD_CHF = price.x.x.x.x, ZAR_USD = price.y.y.y.y ) %>% 
#   na.locf()



# Macroeconomics 
MACROS <- 
  Macro_primes %>% 
  pivot_wider(names_from = commodity_name,values_from = price) %>% 
  na.locf()
MACROS

# Indexes 
INDEX <- 
  Indexes %>% 
  pivot_wider(names_from = Indexes, values_from = price) %>% 
  na.locf()
INDEX

# Commodities 
COMMODITIES <- 
  Commodities %>% 
  pivot_wider(names_from = commodity_name,values_from = price) %>% 
  na.locf()
COMMODITIES

# FX exchanges   
FX <- 
  FX %>% 
  pivot_wider(names_from = currency, values_from = price) %>% 
  na.locf()
FX

# FX exchanges and Primes in one tibble 
FX_PRIMES <- 
  FX_primes %>% 
  pivot_wider(names_from = currency, values_from = price) %>% 
  na.locf()
FX_PRIMES

# Global jointtt
GLOBAL_MARKET_RISK <- 
  MACROS %>% 
  left_join(INDEX, by = c("date" = "date")) %>% 
  left_join(COMMODITIES, by = c("date" = "date")) %>% 
  left_join(FX, by = c("date" = "date")) %>% 
  na.locf()
GLOBAL_MARKET_RISK

#install.packages("openxlsx")

# Lets save our datasets in a easy to read Excel tables, verify the Working Directory.  

getwd()
setwd("C:/Users/ANALITICA/Documents/Thesis DataFrames")

library(openxlsx)

wb <- createWorkbook()
addWorksheet(wb = wb, sheetName = "FX", gridLines = TRUE)
writeDataTable(wb = wb, sheet = 1, x = FX)

openxlsx::write.xlsx(MACROS,             "1.) MACROECONOMICS.xlsx", asTable = TRUE, sheetName = "MACROECONOMICS")
openxlsx::write.xlsx(INDEX,              "2.) INDEX.xlsx", asTable = TRUE, sheetName = "Index")
openxlsx::write.xlsx(COMMODITIES,        "3.) COMMODITIES.xlsx", asTable = TRUE, sheetName = "Commodities")
openxlsx::write.xlsx(FX,                 "4.) FX.xlsx", asTable = TRUE, sheetName = " Currencies")
openxlsx::write.xlsx(FX_PRIMES,          "5.) FX_PRIMES.xlsx", asTable = TRUE, sheetName = "FX and Primes")
openxlsx::write.xlsx(GLOBAL_MARKET_RISK, "6.) GLOBAL_MARKET_RISK.xlsx", asTable = TRUE, sheetName = "Global_Market_Risk") 
# Nuestro pool de datos es de 3578 registros sobre 31 variables. 


# To succesfully combine the 3 assets cathegories into one tidy data tibble, 
# the id label must be the same, 
# then we can spread the data and correlate. 

# GLOBAL_MARKET_RISK 
# Already Tidy 
GLOBAL_MARKET_RISK 

Global_cor <- 
  GLOBAL_MARKET_RISK %>% 
  select(-date) %>% 
  na.locf() %>% 
  cor() 


# Correlation of GLOBAL_MARKET 
Global_market_Corrplot <-  
  corrplot(Global_cor, method = "square",
           tl.col = "darkblue",
           order = "hclust")
Global_market_Corrplot

# ... ----

# 9) PORTFOLIO ####

# Risk Switch :::####

EPU_index <- tq_get("USEPUINDXD", get = "economic.data", from = today()-2000)

# triggers if delta increase 10 % or more OR index equals or its above 90 days mean
EPU_alt <- EPU_index %>%  select(-symbol) %>% 
  mutate(delta = (EPU_index$price)/lag(EPU_index$price)-1)%>% 
  mutate(delta_trigger = ifelse(delta >= 0.10 |
         EPU_index$price >= mean(EPU_index$price + 
                  sd(EPU_index$price)*2.3),1L, 0L)) %>% 
  slice(-1) %>% 
  arrange(desc(date)) %>% 
  rename(index = price, Risk = delta_trigger) %>% 
  mutate(Risk = ifelse(Risk == 1, "OFF", "ON"))
  

# Summary of Risk ON|OFF, current year. 
EPU_abst <-   EPU_alt %>% filter(year(date) >= year(today())) %>% 
  group_by(Risk) %>% summarise(n = n(), .groups = "drop_last") %>% 
  rename( Days = n) %>% 
  mutate("%" = scales::percent( Days/sum(Days))
         )


# FED rate Expectations #####
#browseURL("https://www.economics-finance.org/jefe/fin/KeaslerGoffpaper.pdf")
#browseURL("https://www.cmegroup.com/trading/interest-rates/stir/30-day-federal-fund_quotes_settlements_futures.html")
#browseURL("https://www.danielstrading.com/education/markets/interest-rates-financials/30-day-federal-funds")

#Import data 
# FED Funds Targets (Upper{fftu} & Lower{fftl}) & Fed Funds Futures:::
fftu <- tq_get("DFEDTARU","economic.data", from=today()-2000) # Fed Funds Target Upper 
fftl <- tq_get("DFEDTARL","economic.data", from=today()-2000) # Fed Funds Target Lower
effr <- tq_get("DFF",     "economic.data", from=today()-2000) # Effective Fed Funds Rate Dayly; monthly == FEDFUNDS
fff  <- tq_get("ZQ=F",    "stock.prices" , from=today()-2000) # Fed Funds Futures

# fed funds futures contract
# use fed funds futures contract prices to examine the market’s expectations
# relating to future interest rates 

# If market participants anticipate a rate change by the Fed, the market price of fed funds futures contracts
# will adjust to reflect the anticipated rate change. 
# The fed funds rated implied by futures contracts will
# indicate the magnitude and direction of the anticipated change. 

# Federal Fund futures contracts indicate the average daily federal funds effective rate in a particular month.
# Investors consider Federal Funds to be a satisfactory means for tracking market expectations on federal monetary actions.
# Further, Fed Funds are useful tools for traders that want to manage risk
# and speculate on or hedge against short-term interest rate changes due to changes in monetary policy.


# FedFunds Interest Rates jointed panorama: 

FED_Interest_Rate <- 
fftu %>% rename("FedFunds Target Upper" = price) %>% 
  select(-symbol) %>% left_join(fftl, by = "date") %>% 
  rename("FedFunds Target Lower" = price) %>% 
  select(-symbol) %>% 
  left_join(effr, by = "date") %>% 
  rename("Effective FedFunds Rate" = price) %>% 
  select(-symbol) %>% 
  left_join(fff, by="date") %>% 
  rename("Fed Funds Futures" = symbol) %>% na.locf()


# Beispiel of market Expectations. 
#browseURL("https://www.cmegroup.com/trading/interest-rates/stir/30-day-federal-fund_contractSpecs_futures.html")


interest_rate_current <- tibble(
Date  = fff %>% select(date) %>% filter(date == max(date)) %>% pull(), 
FFF   = fff %>% filter(date == max(date)) %>% pull(adjusted),       # current price for Month fed funds futures.
target_up = fftu %>% filter(date == max(date)) %>% pull(price),     # Upper Target
target_low = fftl %>% filter(date == max(date)) %>% pull(price),    # Lower Target
EFFR   = effr %>% filter(date == max(date)) %>% pull(price),        # current Effective FedFunds
market_expectation = (100-FFF), # fed funds futures rate implied
# Market participants expect that the average fed funds rate for current month will be +0.07%
fed_action = market_expectation-EFFR # The difference between current expectations and current prices.
#                It's important to keep in mind that the difference must be equal or above +- 0.25 bp (basic points)
#                fed_action result it's the probable move o Fed eather positive r negative

) %>%
  mutate(target_range = str_flatten(c(target_low, target_up), collapse = " - "),
         strengh = ifelse(fed_action >= 0.25 | fed_action <= -0.25, "High", "Low"),
         scenario= ifelse(fed_action >= 0.25 | fed_action <= -0.25, "Action", "No Action"),
         direction = if(fed_action > 0.25 & strengh == "High")
         {direction = "Rate High"}
         else if(fed_action < -0.25 & strengh == "High")
         {direction = "Rate Cut"} else{direction = "Constant"},
         ) %>% 
         select(Date, target_range, FFF, EFFR, market_expectation, 
                fed_action, strengh,scenario, direction) 



# Data All for ML , {Interest_rate_all, EPU_alt, asset_selected}


interest_rate_all <- 
  fff %>%   select(date, FFF = adjusted) %>% 
  left_join(fftu, by = "date") %>% 
  rename(target_up = price) %>% 
  select(-symbol) %>% left_join(fftl, by = "date") %>% 
  rename(target_low = price) %>% select(-symbol) %>% 
  left_join(effr, by = "date") %>% 
  rename(EFFR = price) %>% select(-symbol) %>% 
  mutate(market_expectation = 100-FFF,
         fed_action = market_expectation-EFFR) %>% 
  na.locf() %>% 
  select(-target_low, -target_up, -FFF)
# unite(target_range, c(target_low,target_up), sep = " - ") %>% 
# relocate(.before = FFF, target_range)


# Interest Rates graph

ggplotly (
interest_rate_all %>% ggplot(aes(date, EFFR))+
  geom_col(color = "#b1d6f0", fill = "blue")+
  geom_smooth(data = interest_rate_all, 
              aes(x = date, y = market_expectation),
              color = "#e03db7",
              size = 1)+
 geom_smooth(data = EPU_alt,
        aes(x=date, index/250),
        color = "red")+
  theme_classic()+
  labs(title = "Effective Fed Funds Rate vs EPU",
       x_axis = "Date")
)
  

# Asset Selected with TTR:: stats {SMA EMA DEMA ALMA } = Technical Indicators.
asset <- tq_get("SP500", get = "economic.data") 

asset <- asset %>% 
  na.locf() %>% mutate(up = ifelse(price > lag(price), 1, 0)) %>% 
  rename(asset = price) %>% 
  select(-symbol) %>% 
  mutate(sma = SMA(asset, 3),
         ema = EMA(asset, 3),
        dema = DEMA(asset, 3),
        roc  = ROC(asset),
        momentum = momentum(asset),
        rsi = RSI(asset, 5),
        strong_rsi = ifelse(rsi > 80, 1, 0),
        weak_rsi   = ifelse(rsi < 20, 1, 0))
  
  
data <-EPU_alt %>% 
  mutate(Risk = ifelse(Risk == "ON", 1, 0),
         delta= index/lag(index)-1) %>% 
  left_join(interest_rate_all, by = "date") %>% 
  na.locf() %>%
  mutate(delta_h = ifelse(delta > .50, 1, 0),
         delta_l = ifelse(delta < -.50, 1, 0),
         d_1_2_p = ifelse(between(delta, .1,.2), 1,0),
         d_1_2_n = ifelse(between(delta, -.2,-.1), 1,0),
         d_3_5_p = ifelse(between(delta, .3, .5),1, 0),
         d_3_5_n = ifelse(between(delta, -.5, -.3),1,0)) %>% 
  relocate( .after = Risk, contains(c("delt", "d_"))) %>% 
  relocate( .after = market_expectation, fed_action ) %>% 
  mutate(fed_h = ifelse(market_expectation > 1.5, 1, 0 ),
         fed_action_strong = ifelse(fed_action > .09, 1, 0)) %>% 
  left_join(asset, by = "date") %>% na.locf()

# Model Ml

data$up <- factor(data$up)

library(nnet)
library(caret)
library(ROCR)

# partition 
t.id <- createDataPartition(data$up, p= 0.7, list = F)

# Modelo con variable target, class, en funcion del resto V como predictores.
mod <- nnet(up ~ ., data = data[t.id,], 
            size = 5, maxit = 100000, decay = .001, rang = 0.05,
            na.action = na.omit, skip = T)


# Prediccion sobre los datos del conjunto de opuesto al entrenamiento, 
# con el modelo entrenado:
pred <- predict(mod, newdata = data[-t.id,], type = "class")

table(data[-t.id,]$up, pred,dnn = c("Actual", "Predichos"))

# para calcular valores probabilisticos y evaluar desempeño: 
pred2 <- predict(mod, newdata = data[-t.id,], type = "raw")

perf <- performance(prediction(pred2, data[-t.id,"up"]), 
                    "tpr", "fpr")

plot(perf) # Perfect ROCR


# Share::: 

results_nnet <- data %>% 
  select(date,index,Risk,asset,market_expectation,fed_action, up) %>% 
  mutate(pred_up = predict(mod, newdata = data, type = "class"),
         prob_up = predict(mod, newdata = data, type = "raw")[,1]) %>% 
  mutate(prob_up = scales::percent(prob_up, accuracy = 40)) %>% 
  head()




# Google Recession searches --------------------------------------------------------------------

google.trends = gtrends(c("Recession"), gprop = "web", time = "all")[[1]]
google.trends = dcast(google.trends, date ~ keyword + geo, value.var = "hits") 

value <- google.trends %>% 
  as_tibble() %>% mutate(date = as.Date(date)) %>% 
  filter(date == max(date)) %>% 
  pull(Recession_world) 

interest_rate <- interest_rate %>%  mutate(Recession_World = value)

# Fed Rate Move Odds ####

#####

#### time Series ####

library(prophet)
library(tidyverse)
library(tidyquant)
library(lubridate)

setwd("C:/Users/ANALITICA/Desktop")

sp <- tq_get("SP500", get = "economic.data",from = "2020-01-01") %>% 
  select(date, price) %>% 
  dplyr::rename(ds = date, y = price)

# Model
m <- prophet(sp)

# Cross Validation 
sp.cv <- cross_validation(m, initial = 40, period = 30, horizon = 65, units = 'days')
head(sp.cv)

# Performance
sp.p <- performance_metrics(sp.cv)
head(sp.p, 15)

# Cross Visual
plot_cross_validation_metric(sp.cv, metric = 'mape')


future <- make_future_dataframe(m, periods = 8)%>% 
  mutate(weekdays = weekdays(ds)) %>% 
  filter(!weekdays %in% c("Saturday", "Sunday")) %>% 
  select(-weekdays)
tail(future)

forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])


# R
ggplotly( 
  plot(m, forecast)
)

# plotting with dygraphs
library(dygraphs) 
dyplot.prophet(m, forecast)


# Series Components
prophet_plot_components(m, forecast)

# Add checkpoints 
plot(m, forecast) + add_changepoints_to_plot(m)

# R
m <- prophet(DXY_CUR, changepoint.prior.scale = 0.5)
forecast <- predict(m, future)
plot(m, forecast)


#### Sources ::::::::::::::::::::::::::::::::::::::::::::::::::::: ####

#### Simple Portfolio #### 

stock_returns_monthly <- c("AAPL", "GOOG", "NFLX") %>%
  tq_get(get  = "stock.prices",
         from = today()-2000,
         to   = today()) %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "monthly", 
               col_rename = "Ra")
stock_returns_monthly

baseline_returns_monthly <- "XLK" %>%
  tq_get(get  = "stock.prices",
         from = today()-2000,
         to   = today()) %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "monthly", 
               col_rename = "Rb")
baseline_returns_monthly

wts <- c(0.5, 0.0, 0.5)
portfolio_returns_monthly <- stock_returns_monthly %>%
  tq_portfolio(assets_col  = symbol, 
               returns_col = Ra, 
               weights     = wts, 
               col_rename  = "Ra")
portfolio_returns_monthly

wts_map <- tibble(
  symbols = c("AAPL", "NFLX"),
  weights = c(0.5, 0.5)
)
wts_map

stock_returns_monthly %>%
  tq_portfolio(assets_col  = symbol, 
               returns_col = Ra, 
               weights     = wts_map, 
               col_rename  = "Ra_using_wts_map")

RaRb_single_portfolio <- left_join(portfolio_returns_monthly, 
                                   baseline_returns_monthly,
                                   by = "date")
RaRb_single_portfolio

portfolio_returns_monthly %>%
  ggplot(aes(x = date, y = Ra)) +
  geom_bar(stat = "identity", fill = palette_light()[[1]]) +
  labs(title = "Portfolio Returns",
       subtitle = "50% AAPL, 0% GOOG, and 50% NFLX",
       caption = "Shows an above-zero trend meaning positive returns",
       x = "", y = "Monthly Returns") +
  geom_smooth(method = "lm") +
  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::percent)

wts <- c(0.5, 0, 0.5)
portfolio_growth_monthly <- stock_returns_monthly %>%
  tq_portfolio(assets_col   = symbol, 
               returns_col  = Ra, 
               weights      = wts, 
               col_rename   = "investment.growth",
               wealth.index = TRUE) %>%
  mutate(investment.growth = investment.growth * 10000)

portfolio_growth_monthly %>%
  ggplot(aes(x = date, y = investment.growth)) +
  geom_line(size = 2, color = palette_light()[[1]]) +
  labs(title = "Portfolio Growth",
       subtitle = "50% AAPL, 0% GOOG, and 50% NFLX",
       caption = "Now we can really visualize performance!",
       x = "", y = "Portfolio Value") +
  geom_smooth(method = "loess") +
  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar)


monthly_returns_stocks <- FANG %>%
  group_by(symbol) %>%
  tq_transmute(adjusted, periodReturn, period = "monthly")

weights <- c(0.50, 0.25, 0.25, 0)
tq_portfolio(data = monthly_returns_stocks,
             assets_col = symbol,
             returns_col = monthly.returns,
             weights = weights,
             col_rename = NULL,
             wealth.index = FALSE)



#### Multi Portfolio ####

stock_returns_monthly_multi <- stock_returns_monthly %>%
  tq_repeat_df(n = 3)
stock_returns_monthly_multi


weights <- c(
  0.50, 0.25, 0.25,
  0.25, 0.50, 0.25,
  0.25, 0.25, 0.50
)
stocks <- c("AAPL", "GOOG", "NFLX")
weights_table <-  tibble(stocks) %>%
  tq_repeat_df(n = 3) %>%
  bind_cols(tibble(weights)) %>%
  group_by(portfolio)
weights_table


portfolio_returns_monthly_multi <- stock_returns_monthly_multi %>%
  tq_portfolio(assets_col  = symbol, 
               returns_col = Ra, 
               weights     = weights_table, 
               col_rename  = "Ra")
portfolio_returns_monthly_multi

RaRb_multiple_portfolio <- left_join(portfolio_returns_monthly_multi, 
                                     baseline_returns_monthly,
                                     by = "date")
RaRb_multiple_portfolio


portfolio_growth_monthly_multi <- stock_returns_monthly_multi %>%
  tq_portfolio(assets_col   = symbol, 
               returns_col  = Ra, 
               weights      = weights_table, 
               col_rename   = "investment.growth",
               wealth.index = TRUE) %>%
  mutate(investment.growth = investment.growth * 10000)


portfolio_growth_monthly_multi %>%
  ggplot(aes(x = date, y = investment.growth, color = factor(portfolio))) +
  geom_line(size = 2) +
  labs(title = "Portfolio Growth",
       subtitle = "Comparing Multiple Portfolios",
       caption = "Portfolio 3 is a Standout!",
       x = "", y = "Portfolio Value",
       color = "Portfolio") +
  geom_smooth(method = "loess") +
  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar)


# Analize the SP500 Index Portfoloio Returns. 

SP500_returns <- SP500 %>%
  tq_transmute(select = price,
               mutate_fun = periodReturn,
               period = "monthly",
               col_rename = "Ra")


# All Weather : ####

#1.0 IMPORT DATA ----
symbols <- c("VTI", "TLT", "IEF", "GLD", "DBC")
end <- "2019-06-30" %>% ymd()
start <- end - years(30) + days(1)

raw_data <- symbols %>% 
  tq_get(get = "stock.prices",
         from = start,
         to = end)

raw_data %>% 
  group_by(symbol) %>% 
  summarise(min_date = min(date), 
            max_date = max(date))

# 2.0 TRANSFORM TO RETURNS ----
# normal returns
returns_reg_tbl <- raw_data %>% 
  select(symbol, date, adjusted) %>% 
  group_by(symbol) %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "monthly") %>% 
  ungroup() %>% 
  
  #rollback to first day of the month - ETF Issue ----
mutate(date = lubridate::rollback(date, roll_to_first = TRUE))

raw_data %>% 
  select(symbol, date, adjusted) %>% 
  group_by(symbol) %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "monthly") %>% 
  ungroup() %>% 
  spread(symbol, monthly.returns) %>% 
  na.omit()

returns_reg_date_tbl <- returns_reg_tbl %>% 
  group_by(symbol) %>% 
  filter(date >= "2006-02-01")

wts_tbl <- c(0.3, 0.4, 0.15, 0.075, 0.075)

returns_port_tbl <- returns_reg_date_tbl %>% 
  tq_portfolio(assets_col = symbol,
               returns_col = monthly.returns,
               weights = wts_tbl,
               rebalance_on = "years") %>% 
  add_column(symbol = "Portfolio", .before = 1) %>% 
  rename(monthly.returns = portfolio.returns)
end_port_date <- last(returns_port_tbl$date)

returns_port_tbl

# Weights Matrix ####
w_2 <- c(0.3, 0.4, 0.15, 0.075, 0.075,
         1, 0, 0, 0, 0,
         0, 1, 0, 0, 0,
         0, 0, 1, 0, 0,
         0, 0, 0, 1, 0,
         0, 0, 0, 0, 1)

weights_tbl <- tibble(symbols) %>% 
  tq_repeat_df(n = 6) %>% 
  bind_cols(tibble(w_2)) %>% 
  group_by(portfolio)

allocation <- weights_tbl %>%   
  ungroup() %>% 
  mutate(w_2 = paste0(w_2*100, "%")) %>% 
  pivot_wider(names_from = symbols, values_from = w_2) %>% 
  mutate(portfolio = case_when(portfolio == 1 ~ "All Seasons Portfolio",
                               portfolio == 2 ~ "VTI",
                               portfolio == 3 ~ "TLT",
                               portfolio == 4 ~ "IEF",
                               portfolio == 5 ~ "GLD",
                               portfolio == 6 ~ "DBC")) 


##### Multi Returns & Potfolio 

returns_multi_reg_date_tbl <- returns_reg_date_tbl %>% 
  ungroup() %>% 
  tq_repeat_df(n = 6)

port_returns_investment_tbl <- returns_multi_reg_date_tbl %>% 
  tq_portfolio(assets_col = symbol,
               returns_col = monthly.returns,
               weights = weights_tbl,
               wealth.index = TRUE) %>% 
  mutate(investment.growth = portfolio.wealthindex * 10000)

end_port_returns_investment_tbl <- last(port_returns_investment_tbl$date)

# ready to graph. 


# Tech small portfolio: #### 

Ra <- c("AAPL", "GOOG", "NFLX") %>%
  tq_get(get  = "stock.prices",
         from = "2010-01-01",
         to   = "2015-12-31") %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted,  
               mutate_fun = periodReturn, 
               period     = "monthly", 
               col_rename = "Ra")
Ra

# Lets Compare the returns above, wth the XLK SPDR 

Rb <- "XLK" %>%
  tq_get(get  = "stock.prices",
         from = "2010-01-01",
         to   = "2015-12-31") %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "monthly", 
               col_rename = "Rb")
Rb

# Combine the wth a left join. 

RaRb <- left_join(Ra, Rb, by = c("date" = "date"))
RaRb

# Finally, we can retrieve the performance metrics
# Use tq_performance_fun_options() to see the list of compatible performance functions.

RaRb_capm <- RaRb %>% 
  tq_performance(Ra = Ra,
                 Rb = Rb,
                 performance_fun = table.CAPM)
RaRb_capm

# We can isolate attributes, such as alpha = measure of growth & beta, risk measure. 

RaRb_capm %>% 
  select(Alpha, Beta)

# 1A ####
# Get Stock prices .:: 

stock_prices <- 
  c("AAPL", "GOOG", "NFLX") %>% 
  tq_get(get = "stock.prices",
         from = "2010-01-01",
         to = today())
stock_prices

# 2A ####
# Mutate to Returrns :.:

# monthly ...:::
stock_returns_monthly <- 
  stock_prices %>% 
  tq_transmute(select = adjusted, 
               mutate_fun = periodoReturn,
               period = "monthly",
               col_rename = "Ra")

# daily ...::: 
stock_retunrs_daily <- 
  stock_prices %>% 
  tq_transmute( select = adjusted,
                mutate_fun = periodReturn, 
                period = "daily",
                col_rename = "Ra")

# 3A #### 
# Analyze Performance ::.

stock_retunrs_monthly %>% 
  tq_performance(Ra = Ra, 
                 Rb= NULL,
                 performance_fun = SharpeRatio)



# EDA

netflix <- tq_get("NFLX", get = "stock.prices")

# sp_500 <- tq_index("SP500") %>%
#           tq_get(get = "stock.prices")

sp_500 <- tq_index("SP500") %>%
  tq_get(get = "stock.prices") %>%
  group_by(symbol) %>%
  filter(year(date) >= 2017)


# Monthly Returns::
sp_500 %>%
  group_by(symbol) %>%
  tq_transmute(adjusted,mutate_fun = monthlyReturn)

sp_500 <-
  tq_index("SP500") %>%
  tq_get() %>%
  group_by(symbol) %>%
  tq_transmute(adjusted,
               mutate_fun = periodReturn,
               period = "daily",
               type = "log",
               col_rename = "dlr") %>%
  summarize(MDLR  = mean(dlr),
            SDDLR = sd(dlr))

# Evaluating Risk vs Reward for S&P500 Stocks:
sp_500 %>%
  ggplot(aes(x = SDDLR, y = MDLR)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  geom_smooth(method = "lm") +
  labs(title = "Evaluating Risk vs Reward for S&P500 Stocks") +
  theme_tq()


# Yearly Returns :::
FANG_annual_returns <- FANG %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "yearly",
               type = "arithmetic")

FANG_anual_returns


# FANG Annual Returns:

FANG_annual_returns %>%
  ggplot(aes(x = date, y = yearly.returns, fill = symbol)) +
  geom_col() +
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "FANG: Annual Returns",
       subtitle = "Get annual returns quickly with tq_transmute!",
       y = "Annual Returns", x = "") +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  theme_tq() +
  scale_fill_tq()

#  FANG Daily Log returns:

FANG_daily_log_returns <- FANG %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted,
               mutate_fun = periodReturn,
               period     = "daily",
               type       = "log",
               col_rename = "monthly.returns")


# Plotting log Returns:

FANG_daily_log_returns %>%
  ggplot(aes(x = monthly.returns, fill = symbol)) +
  geom_density(alpha = 0.5) +
  labs(title = "FANG: Charting the Daily Log Returns",
       x = "Monthly Returns", y = "Density") +
  theme_tq() +
  scale_fill_tq() +
  facet_wrap(~ symbol, ncol = 2)


FANG %>%
  group_by(symbol) %>%
  tq_transmute(select     = open:volume,
               mutate_fun = to.period,
               period     = "months")

# Daily stock prices:

FANG_daily <- FANG %>%
  group_by(symbol)

FANG_daily %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line(size = 1) +
  labs(title = "Daily Stock Prices",
       x = "", y = "Adjusted Prices", color = "") +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar) +
  theme_tq() +
  scale_color_tq()

# Monthly stock prices:

FANG_monthly <- FANG %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted,
               mutate_fun = to.period,
               period     = "months")

FANG_monthly %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line(size = 1) +
  labs(title = "Monthly Stock Prices",
       x = "", y = "Adjusted Prices", color = "") +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar) +
  theme_tq() +
  scale_color_tq()

# Asset Returns

---------------------------------------
  
  FANG_returns_monthly <- FANG %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted,
               mutate_fun = periodReturn,
               period     = "monthly")

# Baseline Returns
baseline_returns_monthly <- "XLK" %>%
  tq_get(get  = "stock.prices",
         from = "2016-01-01",
         to   = Sys.Date()) %>%
  tq_transmute(select     = adjusted,
               mutate_fun = periodReturn,
               period     = "monthly")

returns_joined <- left_join(FANG_returns_monthly,
                            baseline_returns_monthly,
                            by = "date")
returns_joined



# Rolling Correlations: !!!! #### 

FANG_rolling_corr <- returns_joined %>%
  tq_transmute_xy(x          = monthly.returns.x,
                  y          = monthly.returns.y,
                  mutate_fun = runCor,
                  n          = 6,
                  col_rename = "rolling.corr.6")

FANG_rolling_corr %>%
  ggplot(aes(x = date, y = rolling.corr.6, color = symbol)) +
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  geom_line(size = 1.5) +
  labs(title = "FANG: Six Month Rolling Correlation to XLK",
       x = "", y = "Correlation", color = "") +
  facet_wrap(~ symbol, ncol = 2) +
  theme_tq() +
  scale_color_tq()

------------------------------------------------------
  
  # Moving Average Convergence Divergence (MACD)
  
  FANG_macd <- FANG %>%
  group_by(symbol) %>%
  tq_mutate(select     = close,
            mutate_fun = MACD,
            nFast      = 12,
            nSlow      = 26,
            nSig       = 9,
            maType     = SMA) %>%
  mutate(diff = macd - signal) %>%
  select(-(open:volume))
FANG_macd


FANG_macd %>%
  filter(date >= as_date("2016-10-01")) %>%
  ggplot(aes(x = date)) +
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  geom_line(aes(y = macd, col = symbol)) +
  geom_line(aes(y = signal), color = "blue", linetype = 2) +
  geom_bar(aes(y = diff), stat = "identity", color = palette_light()[[1]]) +
  facet_wrap(~ symbol, ncol = 2, scale = "free_y") +
  labs(title = "FANG: Moving Average Convergence Divergence",
       y = "MACD", x = "", color = "") +
  theme_tq() +
  scale_color_tq()

# by quater

FANG_max_by_qtr <- FANG %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted,
               mutate_fun = apply.quarterly,
               FUN        = max,
               col_rename = "max.close") %>%
  mutate(year.qtr = paste0(year(date), "-Q", quarter(date))) %>%
  select(-date)
FANG_max_by_qtr

# Visualize

FANG_by_qtr %>%
  ggplot(aes(x = year.qtr, color = symbol)) +
  geom_segment(aes(xend = year.qtr, y = min.close, yend = max.close),
               size = 1) +
  geom_point(aes(y = max.close), size = 2) +
  geom_point(aes(y = min.close), size = 2) +
  facet_wrap(~ symbol, ncol = 2, scale = "free_y") +
  labs(title = "FANG: Min/Max Price By Quarter",
       y = "Stock Price", color = "") +
  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.title.x = element_blank())

# Get stock pairs
stock_prices <- c("MA", "V") %>%
  tq_get(get  = "stock.prices",
         from = "2015-01-01",
         to   = "2016-12-31") %>%
  group_by(symbol)

stock_pairs <- stock_prices %>%
  tq_transmute(select     = adjusted,
               mutate_fun = periodReturn,
               period     = "daily",
               type       = "log",
               col_rename = "returns") %>%
  spread(key = symbol, value = returns)

stock_pairs %>%
  ggplot(aes(x = V, y = MA)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  geom_smooth(method = "lm") +
  labs(title = "Visualizing Returns Relationship of Stock Pairs") +
  theme_tq()


# Stock Monthly Returns

stock_returns_monthly <- c("AAPL", "GOOG", "NFLX") %>%
  tq_get(get  = "stock.prices",
         from = "2010-01-01",
         to   = "2015-12-31") %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted,
               mutate_fun = periodReturn,
               period     = "monthly",
               col_rename = "Ra")


baseline_returns_monthly <- "XLK" %>%
  tq_get(get  = "stock.prices",
         from = "2010-01-01",
         to   = "2015-12-31") %>%
  tq_transmute(select     = adjusted,
               mutate_fun = periodReturn,
               period     = "monthly",
               col_rename = "Rb")
baseline_returns_monthly

# weights Matrix

wts <- c(.5, 0, .5)
portfolio_returns_monthly <- stock_returns_monthly %>%
  tq_portfolio(assets_col   = symbol,
               returns_col  = Ra,
               weights = wts,
               col_rename = "Ra")
portfolio_returns_monthly

wts_map <- tibble(
  symbols = c("AAPL", "NFLX"),
  weights = c(0.5, 0.5)
)
wts_map


#........####

# 10) Alternative Data Source #### 

# Covid-19 ####

# Coronavirus Data & package ; Integrate to Prescription::

library(coronavirus)

corona_data <- coronavirus::coronavirus %>% filter(type == "confirmed") %>% 
  group_by(date) %>% summarise(cases = sum(cases), .groups = "drop_last")

# GitHub about ::: 
#browseURL("https://github.com/RamiKrispin/coronavirus") 

# Rank:
conf_df <- coronavirus %>% 
  filter(type == "confirmed") %>%
  group_by(country) %>%
  summarise(total_cases = sum(cases), .groups = "drop_last") %>%
  arrange(-total_cases) %>%
  mutate(parents = "Confirmed") %>%
  ungroup() 

plot_ly(data = conf_df,
        type= "treemap",
        values = ~total_cases,
        labels= ~ country,
        parents=  ~parents,
        domain = list(column=0),
        name = "Confirmed",
        textinfo="label+value+percent parent")

# Web Scrapping ####
library(rvest)

eco_cal <- "https://tradingeconomics.com/calendar"
read_html(eco_cal)
agenda <- read_html(eco_cal)
str(agenda)

body_nodes <- agenda %>% 
  html_node("body") %>% 
  html_children()
body_nodes

body_nodes %>% 
  html_children()

times <- agenda %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//tr[contains(@width, '100')]") %>% 
  rvest::html_text()

str_remove_all(times, "[\r\n]") %>% str_trim()   -> xx



#Bureau of Economic Analisys
bea_key <- "E04E3BF7-96B7-4057-B376-DFA2B1F9B251"

beaSets( "E04E3BF7-96B7-4057-B376-DFA2B1F9B251")

# Alpha Vantage Data: ####
# To get Market data in Alpha: 

# install.packages("alphavantager")
# browseURL("https://www.alphavantage.co/documentation/")
# alphak = "K40OVQLGD2QIE4TO"

av_api_key("K40OVQLGD2QIE4TO")

# aplicable to currencies
my_intraday_data <- c("FB", "MSFT") %>%
  tq_get(get = "alphavantager", av_fun = "TIME_SERIES_INTRADAY", interval = "1min")

eur_usd <- c("EURUSD") %>%
  tq_get(get = "alphavantager", av_fun = "TIME_SERIES_INTRADAY", interval = "1min")

my_intraday_data <- c("FB", "MSFT") %>%
  tq_get(get = "alphavantager", av_fun = "TIME_SERIES_DAILY_ADJUSTED")



#Intraday data for indexes: 

#SP500
sp_data <- c("SPX") %>%
  tq_get(get = "alphavantager", av_fun = "TIME_SERIES_INTRADAY", interval = "1min")

#DOW JONES
dow_data <- c("DJIA") %>%
  tq_get(get = "alphavantager", av_fun = "TIME_SERIES_INTRADAY", interval = "1min")

#NDAQ ?? 
# my_intraday_data <- c("COMP") %>%
#   tq_get(get = "alphavantager", av_fun = "TIME_SERIES_INTRADAY", interval = "1min")


EURUSD <- tq_get(get = "alphavantager", av_fun = "CURRENCY_EXCHANGE_RATE",
                 from_currency=USD, to_currency=EUR, interval = "30min", 
                 outputsize = compact, apikey = "K40OVQLGD2QIE4TO")




# SMA
av_get(symbol = "EURUSD", av_fun = "SMA", interval = "5min", time_period = 60, series_type = "close") %>% print(n=100)



# INTRADAY DATA 
# output size = "compact" # For daily data.
# interval = "1min"

# option available also for stocks 

setDefaults(getSymbols.av, api.key="K40OVQLGD2QIE4TO")

getSymbols("EURUSD",
           src="av",
           api.key="K40OVQLGD2QIE4TO",
           output.size="full",
           periodicity="intraday")

getSymbols("GBPUSD",
           src="av", 
           api.key="K40OVQLGD2QIE4TO",
           output.size="full",
           periodicity="intraday")

getSymbols("GBPUSD",
           src = "av",
           api.key = "K40OVQLGD2QIE4TO", 
           output.size = "full",
           periodicity = "daily")

EURUSD %>% tail(); GBPUSD %>% tail()

# browseURL( "https://www.rdocumentation.org/packages/quantmod/versions/0.4-15/topics/getSymbols.av")

# More Data sources: ####
# browseURL("https://towardsdatascience.com/free-financial-data-a122a3cd5531")
# browseURL("https://www.openquants.com")


# SEC ####
install.packages("finreportr")
library(finreportr)

#General info :
AAPL.Info<-CompanyInfo("AAPL")
#Reports accesion: 
AAPL.reports<-AnnualReports("AAPL")

# Essentially Company financials are organized into 3 segments: 
# Income statement, Balance sheet & Cash flow: 
AAPL.IS <- GetIncome("AAPL", 2017)

#Metrics:
unique(AAPL.IS$Metric)

# Balance Sheet: 
AAPL.BS<-GetBalanceSheet("AAPL", 2017) 

# Cash Flow: 
AAPL.CF<-GetCashFlow("AAPL", 2018)

# Quandl ####
# browseURL("https://www.quandl.com/")

install.packages("Quandl")
library(Quandl)

Quandl.api_key("5qWrGohi2Gx16o4zG-o7")
from.dat <- as.Date("01/01/2010", format="%d/%m/%Y")
to.dat <- as.Date("01/01/2019", format="%d/%m/%Y")
crude.oil.futures<-Quandl("CHRIS/CME_CL1", start_date = from.dat, end_date = to.dat, type="xts")
plot(crude.oil.futures$Last)




gold.futures<-Quandl("CHRIS/CME_GC6", start_date = from.dat, end_date = to.dat, type="xts")
plot(gold.futures$Last)


gold_futures <- 
  Quandl("CHRIS/CME_GC6", api_key="5qWrGohi2Gx16o4zG-o7")

fred.GDP <- Quandl("FRED/GDP", type = "xts")
plot(fred.GDP)

# Slice & Dice: 
GDP = Quandl("FRED/GDP", start_date="2001-12-31", end_date="2005-12-31", type = "xts") 

# sampling data: 
Quandl("FRED/GDP", collapse="annual")
Quandl("FRED/GDP", transform="rdiff")


mydata = Quandl.datatable("ZACKS/FC",
                          ticker=c("AAPL", "MSFT"),
                          per_end_date.gt="2015-01-01",
                          qopts.columns=c("m_ticker", "per_end_date", "tot_revnu"))


# Tables wth GT 


# Define the start and end dates for the data range

start_date <- "2010-06-07"
end_date <- "2010-06-14"

# Create a gt table based on preprocessed

# `sp500` table data

sp500 %>%
  dplyr::filter(date >= start_date & date <= end_date) %>%
  dplyr::select(-adj_close) %>%
  gt() %>%
  tab_header(
    title = "S&P 500",
    subtitle = glue::glue("{start_date} to {end_date}")
  ) %>%
  
  fmt_date(
    columns = vars(date),
    date_style = 3
  ) %>%
  fmt_currency(
    columns = vars(open, high, low, close),
    currency = "USD"
  ) %>%
  
  fmt_number(
    columns = vars(volume),
    suffixing = TRUE
  )



# browseURL("https://rpubs.com/the5ac/all_seasons_portfolio_part1")



#Financial Maths ####
#Modelling a cash flow ####

#https://bookdown.org/wfoote01/faur/r-warm-ups-in-finance.html

rates <- c(0.06, 0.07, 0.05, 0.09, 0.09, 
           0.08, 0.08, 0.08)
t <- seq(1, 8)

(pv.1 <- sum(1/(1 + rates)^t))


#Twitter info  scrapping ########
library(rtweet)
#trends
trends <- get_trends()

#make a tweet 
post_tweet("my first rtweet #rstats")


#Basic search 
search_tweets("economy", 10,  include_rts = FALSE)
#where q = subject; n = quantity


#More specific Search
q <- "economic crisis"
n <- 10000
#since <- "2016-12-01"
since <- today()-2000
until <- today()
rt <- search_tweets(
  q = q, n = n, type = "recent", 
  since = since, until = until)

## preview users data
users_data(rt)

## plot time series (if ggplot2 is installed)
ts_plot(rt)

## plot time series of tweets
ts_plot(rt, "3 hours") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency about #economic crises Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

## search for 10,000 tweets sent from the US
rt <- search_tweets(
  "lang:en", geocode = lookup_coords("usa"), n = 10000
)


## search for 250,000 tweets containing the word data
# to request more than rate limits:::
rt <- search_tweets(
  "data", n = 250000, retryonratelimit = TRUE
)

## get user IDs of accounts followed by CNN
tmls <- get_timelines(c("cnn", "BBCWorld", "foxnews"), n = 3200)

## plot the frequency of tweets for each user over time
tmls %>%
  dplyr::filter(created_at > "2017-10-29") %>%
  dplyr::group_by(screen_name) %>%
  ts_plot("days", trim = 1L) +
  ggplot2::geom_point() +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    legend.title = ggplot2::element_blank(),
    legend.position = "bottom",
    plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of Twitter statuses posted by news organization",
    subtitle = "Twitter status (tweet) counts aggregated by day from October/November 2017",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

## lookup users by screen_name or user_id
users <- c("business", "markets", "businessinsider","FT", "YahooFinance",
           "wef", "WSJmarkets","economics","CNBC","AndgTrader")
tweeters <- lookup_users(users)



# tw 4 QuantApp ####



#Make query of specific content:
#recession:::

#Main Funciton ::: 

#user need to use accents:
tt <- function(ttt){
  rst <- search_tweets(q = ttt, n = 100, include_rts = FALSE)
  return(rst)
}

#user just need to type:
tt <- function(ttt){
  rst= search_tweets(q = paste0(",ttt,"), n = 100, include_rts = FALSE)
  return(rst)
}

recession_rt <- search_tweets(
  "#recession", n = 10000, include_rts = FALSE
)
#}

bullish_rt <- search_tweets(
  "#bullish", n = 10000, include_rts = FALSE
)

bearish_rt <- search_tweets(
  "#bearish", n = 10000, include_rts = FALSE
)



# read text in datatable

recession_rt <- search_tweets(
  "#recession", n = 10000, include_rts = FALSE
) %>% group_by(screen_name) %>% 
  filter(created_at == max(created_at)) %>% 
  select(screen_name, text)%>% 
  rename(Accounts=screen_name,Tweets = text) %>% 
  datatable(style = 'default', rownames = F)


#bullish
bullish_rt <- search_tweets(
  "#bullish", n = 10000, include_rts = FALSE
) %>% group_by(screen_name) %>% 
  filter(created_at == max(created_at)) %>% 
  select(screen_name, text) %>% 
  rename(Accounts=screen_name,Tweets = text) %>% 
  datatable(style = 'default', rownames = F)


#bullish
bearish_rt <- search_tweets(
  "#bullish", n = 10000, include_rts = FALSE
) %>% group_by(screen_name) %>% 
  filter(created_at == max(created_at)) %>% 
  select(screen_name, text) %>% 
  rename(Accounts=screen_name,Tweets = text) %>% 
  datatable(style = 'default', rownames = F)



#visualize freq
recession_tw_freq <- 
  ts_plot(recession_rt, "5 hours") +
  ggplot2::theme_minimal() +
  ggplot2::geom_line(color='#1da1f2', size=1.5)+
  ggplot2::geom_point(color="#D16082", size=4)+
  ggplot2::geom_smooth(color="green")+
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #recession Twitter statuses from past 7 days",
    subtitle = "Twitter status (tweet) counts aggregated using Five-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

## lookup expert users opinion by screen_name or user_id
users <- c("business", "markets", "businessinsider","FT", "YahooFinance",
           "wef", "WSJmarkets","economics","AndgTrader")

vip_tweeters <- lookup_users(users) %>% 
  select(screen_name, text) %>% 
  rename(ACCOUNT = screen_name,
         TWEET = text) %>% head(30) %>%
  gt()



# Google Trends ####
# add 2 Sentiment Analisys

library(gtrendsR)
library(reshape2)

google.trends = gtrends(c("Recession"), gprop = "web", time = "all")[[1]]
google.trends = dcast(google.trends, date ~ keyword + geo, value.var = "hits")

ggplotly(
  google.trends %>% as_tibble() %>% ggplot(aes(x=date, y = Recession_world))+
    geom_line(color = "blue")+
    geom_point( color = "blue")+
    geom_smooth(color = "pink")+
    theme_classic()+
    labs(x = "Date", y = " Ressecion Search" , 
         title = "Google Trends")
)

#h2o Ensemble Prediction Model ####

library(tidyverse)
library(readxl)
library(h2o)

# ReaData
path = "data.xlsx"
sheets <- excel_sheets(path)


# Index Match
data_joined_tbl <- sheets[4:7] %>% 
  map(~read_excel(path = path, sheet = .)) %>% 
  reduce(left_join) 

data_joined_tbl # TERM_DEPOSIT it's the value to predict


# Start Cluster ----
h2o.init()

# Convert string columns to factors (aka "enum") type for algo interpretation
data_joined_tbl <- data_joined_tbl %>% 
  mutate_if(is.character, as.factor)


# split-data ----
# to split data if we already have the info into an object
# Speed up:    options("h2o.use.data.table = TRUE") # 4Real bigdata
train <- as.h2o(data_joined_tbl)

# Take a look at the training set 
h2o.describe(train) 
# observe missing values, Labels & Cardenality in case of values
# with very high carnality we can exclude them or range them.
# Labels == Features

# Identify response column 
y <- "TERM_DEPOSIT"

# If our binary response column was encoded as 0/1 then we have to convert it
# to factor in order to tell H2O to perform classification instead of regression.
# Since our response is already a fector/enum <- cathegorical type, but if not:
#train[,y] <- as.factor(train[,y])

# Identify the predictor columns (remove response and ID column)
x <- setdiff(names(train),c("Y","ID")) # Predictors

# Training AutoML ----

aml <- h2o.automl( 
  y = y,
  x = x,
  training_frame = train,
  project_name = "term_deposit",
  max_models = 10,
  seed = 1 )


# LeaderBoard ----
# Next, let's observe the AutoML Leaderboard. Since we did not specify a 
# 'leaderboard_frame', scoring & ranking uses cross-validation metrics

# A default performance metric for each machine learning task (binary classification,
# multiclass regression) is specified internally and the leaderboard will be sorted.
# In the classification, the default ranking metric is Area Under ROC Curve (AUC).

# The leader model is stored at 'aml@leader' & the leaderboard it's in 'aml@leaderboard'.
lb <- aml@leaderboard


# Let's see a snapshot of the top models . Here we should see the two Stacked Ensembles
# at or near the top of the leaderboard. Stacked Ensembles can almost always outperform
print(lb) # we got model_id, metrics represents cross validated performance 4 each.

#Entire Leaderboard, specify the 'n' arguments
#priint(lb, n = nrow(lb))

#Ensemble Exploration ----

# To understand how ensemble works, let's take a peek inside the Stacked Ensemble.
# "All Models" ensemble is an ensemble of all individual models in the AutoML run.
# This is often the top performing model on the leaderboard.

# Get model ids for all models in the AutoML Leaderboard.
model_ids <- as.data.frame(aml@leaderboard$model_id)[,1]
# Get the "All Models" Stacked Ensemble Model 
se <- h2o.getModel(grep("StackedEnsemble_AllModels",model_ids, value=TRUE)[1])
# Get the Stacked Ensemble model 
metalearner <- h2o.getModel(se@model$metalearner$name)

# Examine the variable importance of the metalearner (combiner) algorithm in the ensemble.
# This shows ushow much each base learner is contributing to the ensemble. The AutoML Stacked
# use the defaul metalearner algorithm (GLM with non-negative weights), so the variable importance
# metalearner is actually the standardized coefficient magnitudes of the GLM.
# Tbl ----
h2o.varimp(metalearner)
# How important each of the base learners is 2 the ensemble
# XGBoost and XRT(extremely randomized trees), DRF(distributed random forest),GBM,GML
# observe coefficients column

# We can also plot the base learner contributions to the ensemble. 
# Plot ----
h2o.varimp_plot(metalearner)

# VImportance ----
# Let's see the variable importance on the training set using the top
# (Stacked ensembles don't have variable importance yet)
# grab ----
xgb <- h2o.getModel(grep("XGBoost", model_ids, value = TRUE)[1])

# Variable Importance of the top XGBoost Model
h2o.varimp(xgb)

# Plot the base learner contribution to the ensemble.
h2o.varimp_plot(xgb)

xgb@parameters




fth  <- read.csv("fth.csv") 
rfth <- fth %>% filter(STATUS %in% c("Approved","Completed","Processing"))
perfomance<-rfth %>% group_by(TYPE) %>% summarise(n=n(),Amount=sum(AMOUNT))
d <-  perfomance %>% slice(1) %>% pull(Amount)
w<-  perfomance %>% slice(2) %>% pull(Amount)
pl <- w-d
trm <- 3250
ppl<-pl*trm


# 3D Graphs

library(threejs)
suppressMessages(library(igraph))

d <- as.matrix(read.csv(url("https://quantdare.com/wp-content/uploads/2018/12/dji_comp_distance.csv"), sep=',', header=FALSE))
mynames <- c("MMM","AXP","AAPL","BA","CAT","CVX","CSCO","KO","XOM","GS","HD","INTC","IBM","JNJ","JPM","MCD","MRK","MSFT","NKE","PFE","PG","UTX","UNH","VZ","WMT","WBA","DIS")
mycolors <- c("#CA7CFF","#00BFC7","#FF5FC8","#CA7CFF","#CA7CFF","#06BB66","#FF5FC8","#7AAC09","#06BB66","#00BFC7","#BD983E","#FF5FC8","#FF5FC8","#00A9FC","#00BFC7","#BD983E","#00A9FC","#FF5FC8","#BD983E","#00A9FC","#7AAC09","#CA7CFF","#00A9FC","#F57678","#7AAC09","#7AAC09","#F57678")

Q = d * (d<0.25)
g = graph.adjacency(Q, mode="undirected", weighted=TRUE, diag=FALSE)
g = set_vertex_attr(g, "color", value=mycolors)
graphjs(g,
        vertex.size=0.2,
        vertex.shape=mynames)


browseURL("https://quantdare.com/more-examples-in-financial-visualisation/")



### Black & Sholes ####

BlackScholes <- function(S, K, r, T, sig, type){
  
  if(type=="C"){
    d1 <- (log(S/K) + (r + sig^2/2)*T) / (sig*sqrt(T))
    d2 <- d1 - sig*sqrt(T)
    
    value <- S*pnorm(d1) - K*exp(-r*T)*pnorm(d2)
    return(value)}
  
  if(type=="P"){
    d1 <- (log(S/K) + (r + sig^2/2)*T) / (sig*sqrt(T))
    d2 <- d1 - sig*sqrt(T)
    
    value <-  (K*exp(-r*T)*pnorm(-d2) - S*pnorm(-d1))
    return(value)}
}
 

call <- BlackScholes(110,100,0.04,1,0.2,"C")
put  <- BlackScholes(110,100,0.04,1,0.2,"P")



# volatility ####
library(quantmod)
library(PerformanceAnalytics)

tickers = c("^RUT","^STOXX50E","^HSI", "^N225", "^KS11")
myEnv <- new.env()
getSymbols(tickers, src='yahoo', from = "2003-01-01", env = myEnv)
index <- do.call(merge, c(eapply(myEnv, Ad), all=FALSE))

#Calculate daily returns for all indices and convert to arithmetic returns
index.ret <- exp(CalculateReturns(index,method="compound")) - 1
index.ret[1,] <- 0

#Calculate realized volatility
realizedvol <- rollapply(index.ret, width = 20, FUN=sd.annualized)


# Annualized Stats ----

sp500_returns <- tq_get("SP500", "economic.data")%>%
  na.locf() %>% 
  tq_transmute(select = price,
               mutate_fun = periodReturn,
               period = "monthly",
               type = "log") %>% na.locf() %>% 
  column_to_rownames("date") %>% 
  rename(Asset = "monthly.returns")

# Calculate the mean, volatility, and Sharpe ratio of sp500_returns
sd_ann <- StdDev.annualized(sp500_returns)


# plotly chart 
chart.RollingPerformance(R = sp500_returns, width = 6, FUN = "StdDev.annualized",
                         main = "Rolling 6-Month Standard Deviation", plot.engine = "plotly") 


# Changing the FUN, the output can adopt in addition, Returns or Sharpe 



# VaR ----

library(PerformanceAnalytics)
library(reshape2)
library(ggplot2)


# VaR & CVaR 95% 

# 95%
var_95_hist   <- VaR(sp500_returns, p=0.95, method="historical")
var_95_gauss  <- VaR(sp500_returns, p=0.95, method="gaussian")
var_95_mod    <- VaR(sp500_returns, p=0.95, method="modified")
cvar_95_hist  <- CVaR(sp500_returns, p=0.95, method="historical")
cvar_95_gauss <- CVaR(sp500_returns, p=0.95, method="gaussian")
cvar_95_mod   <- CVaR(sp500_returns, p=0.95, method="modified")


# 99%
var_99_hist   <- VaR(sp500_returns, p=0.99, method="historical")
var_99_gauss  <- VaR(sp500_returns, p=0.99, method="gaussian")
var_99_mod    <- VaR(sp500_returns, p=0.99, method="modified")
cvar_99_hist  <- CVaR(sp500_returns, p=0.99, method="historical")
cvar_99_gauss <- CVaR(sp500_returns, p=0.99, method="gaussian")
cvar_99_mod   <- CVaR(sp500_returns, p=0.99, method="modified")



vars_95 <- data.frame(rbind(var_95_hist,
                            var_95_gauss, 
                            var_95_mod,
                            cvar_95_hist,
                            cvar_95_gauss,
                            cvar_95_mod
                             ))


rownames(vars_95)<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
vars_95$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")

var_plot_95 <- melt(vars_95, value.name = "Value_at_Risk") %>% mutate(TailVaR = str_detect(type, "CVaR"),
                                                                      TailVaR = ifelse(TailVaR == "TRUE",1,0))



ggplotly(
ggplot(var_plot_95,aes(x=type, y=Value_at_Risk, fill=TailVaR)) + geom_col()
)


vars_99 <- data.frame(rbind(var_99_hist,
                            var_99_gauss, 
                            var_99_mod,
                            cvar_99_hist,
                            cvar_99_gauss,
                            cvar_99_mod
))


rownames(vars_99)<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
vars_99$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")

var_plot_99 <- melt(vars_99, value.name = "Value_at_Risk") %>% mutate(TailVaR = str_detect(type, "CVaR"))


ggplotly(
  ggplot(var_plot_99,aes(x=type, y=Value_at_Risk, fill=TailVaR)) + geom_col()
)


# . ----
# ... ----
# ....... ---- 
# ........... ---- 







### Andres Garcia ----
### Market Risk Analisys ---- 
### MQF - MBA Thesis. ---- 
