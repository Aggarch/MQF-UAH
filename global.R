# Global ####

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
library(gt)
library(rtweet)
library(gargle)
library(openxlsx)


source("funciones/boton_descarga.R")

# 1.) market_list ####

market_list <- list(    
  Macroeconomics = c("Global GDP"                   = "NYGDPPCAPKDWLD",
                     "Economic Policy Risk"         = "USEPUINDXD",
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
  Commodities    = c("WTI"                          = "WTISPLC",
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
                     "USD SEK"                      = "DEXSDUS"),
  ETFs           = c("Vanguard Total Stock"         = "VTI",
                     "Blackrock Treasury 20y"       = "TLT",
                     "Blackrock Treasury 7-10y"     = "IEF",
                     "SPDR Gold Trust"              = "GLD",
                     "Invesco DB Commodity"         = "DBC",
                     "Technology SPDR Fund"         = "XLK")
  
)







