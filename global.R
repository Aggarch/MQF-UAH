# Global ####


# Libraries ::: 

#install.packages("tidyverse")


library(shiny)
library(shinydashboard)
library(tidyverse)
library(tidyquant)
library(timetk)
library(corrplot)
library(alphavantager)
library(ggplot2)
library(plotly)
library(quantmod)
library(ggplot2)
library(forecast)
library(tseries)
library(DT)
library(ggplot2)
library(prophet)
library(shinyWidgets)
library(lubridate)
library(shinycssloaders)
library(plotly)
library(rtweet)
library(gargle)
library(openxlsx)
library(shinyalert)
library(gtrendsR)
library(gt)
library(reshape2)
library(reactable)
library(coronavirus)
library(nnet)
library(caret)
library(ROCR)
library(TTR)
library(skimr)
library(devtools)
library(rugarch)
library(PerformanceAnalytics)



# 1.) market_list ####

market_list <- list(    
  Macroeconomics = c("Economic Policy Risk"         = "USEPUINDXD",
                     "Global Economic Uncertainty"  = "GEPUPPP",
                     "Trade Policy Risk"            = "CHNMAINLANDTPU",
                     "Houses Month supply"          = "MSACSR",
                     "CPI"                          = "CPIAUCSL",
                     "Real GDP"                     = "A191RL1Q225SBEA",
                     "IPI"                          = "INDPRO",
                     "Non Farm Payrolls"            = "PAYEMS",
                     "Unemployment Rate"            = "UNRATE",
                     "Treasury 10y"                 = "DGS10",
                     "Treasury 2y"                  = "GS2",
                     "FED Interest Rate"            = "FEDFUNDS"),
  Indexes        = c("Standard & Poors 500"         = "SP500",
                     "Dow Jones"                    = "DJIA",
                     "Nasdaq Composite"             = "NASDAQCOM",
                     "Nikkei"                       = "NIKKEI225",
                     "VIX"                          = "VIXCLS"),
  Commodities    = c("WTI"                          = "DCOILWTICO",
                     "Brent"                        = "POILBREUSDM",
                     "Gold"                         = "GOLDAMGBD228NLBM",       
                     "Aluminium"                    = "PALUMUSDM",      
                     "Corn"                         = "PMAIZMTUSDM",        
                     "Soy"                          = "PSOYBUSDQ"),       
  Currencies     = c("DXY CUR"                      = "DTWEXAFEGS",
                     "EUR USD"                      = "DEXUSEU",
                     "GBP USD"                      = "DEXUSUK",
                     "USD JPY"                      = "DEXJPUS",
                     "USD CAD"                      = "DEXCAUS",
                     "AUD USD"                      = "DEXUSAL",
                     "USD CHF"                      = "DEXSZUS",
                     "USD SEK"                      = "DEXSDUS",
                     "BTC USD"                      = "CBBTCUSD",
                     "ETH USD"                      = "CBETHUSD"),
  ETFs           = c("Vanguard Total Stock"         = "VTI",
                     "Blackrock Treasury 20y"       = "TLT",
                     "Blackrock Treasury 7-10y"     = "IEF",
                     "SPDR Gold Trust"              = "GLD",
                     "Invesco DB Commodity"         = "DBC",
                     "Technology SPDR Fund"         = "XLK")
  
)


# FED Funds Targets (Upper{fftu} & Lower{fftl}) & Fed Funds Futures:::
fftu <- tq_get("DFEDTARU","economic.data", from=today()-2000) # Fed Funds Target Upper 
fftl <- tq_get("DFEDTARL","economic.data", from=today()-2000) # Fed Funds Target Lower
effr <- tq_get("DFF",     "economic.data", from=today()-2000) # Effective Fed Funds Rate Dayly; monthly == FEDFUNDS
fff  <- tq_get("ZQ=F",    "stock.prices" , from=today()-2000) # Fed Funds Futures

# Economic Policy Uncertaint Index 
EPU_index <- tq_get("USEPUINDXD", get = "economic.data", from = today()-2000)

garchspec <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                        variance.model = list(model = "sGARCH"), 
                        distribution.model = "norm")

# Notes : add , summary(data_pred_show$ASSET), to describe module


# downloable forecast 
source("funciones/boton_descarga.R")








