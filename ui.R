

# 0.) ui ####
skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
  skin <- "black"


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
  ETFs           = c("Vanguard"                     = "VLT")
  
)





# 2.) dashboardPage ####
ui <- dashboardPage(
      dashboardHeader(title = 'QuanTrader', titleWidth = 250, 
                      
                      tags$li(class="dropdown",tags$a(href="https://github.com/Aggarch/MQF-UAH", 
                                                      icon("github","fa-2x"), "",
                                                      style= "padding-left:27px,width:650px;height:40px",
                                                      target="_blank")),
                      tags$li(class="dropdown",tags$a(href="https://www.teletrader.com/", 
                                                      icon("accusoft","fa-2x"), "",
                                                      style= "padding-left:27px,width:650px;height:40px",
                                                      target="_blank")),
                      tags$li(class="dropdown",tags$a(href="https://twitter.com/AndgTrader", 
                                                      icon("twitter","fa-2x"), "",
                                                      style= "padding-left:27px,width:650px;height:40px",
                                                      target="_blank")),
                      tags$li(class="dropdown",tags$a(href="https://www.bloomberg.com/", 
                                                      icon("newspaper","fa-2x"), "",
                                                      style= "padding-left:27px,width:650px;height:40px",
                                                      target="_blank"))),
      dashboardSidebar(width = 250,
                   sidebarMenu(
                     menuItem("Home", tabName = "home", icon = icon("home")),
                     menuItem("Description", tabName = "description", icon = icon("poll")
                              # menuSubItem('Macroeconomics', tabName = 'macroeconomics', icon = icon("circle-notch")),
                              # menuSubItem('Indexes', tabName = 'indexes',  icon = icon("circle-notch")),
                              # menuSubItem('Comodities', tabName = 'comodities',  icon = icon("circle-notch")),
                              # menuSubItem('Currencies', tabName = 'comodities',  icon = icon("circle-notch"))
                     ),
                     menuItem("Prediction", tabName = "prediction", icon = icon("project-diagram")
                              # menuSubItem('FedMeeting Matrix', tabName = 'fedmeetings', icon = icon("circle-notch")),
                              # menuSubItem('Time series', tabName = 'timeseries', icon = icon("circle-notch")),
                              # menuSubItem('Montecarlo', tabName = 'montecarlo', icon = icon("circle-notch"))
                     ),
                     menuItem("Prescription", tabName = "prescription", icon = icon("chart-line")
                              # menuSubItem('Portfolio', tabName = 'portfolio', icon = icon("circle-notch")),
                              # menuSubItem('Notes', tabName = 'notes', icon = icon("circle-notch"))
                     ),
                     br(), br(),br(),br(),br(),  br(), br(),br(),br(),br(),
                     br(), br(),br(),br(),br(),  br(), br(),br(),br(),br(),
                     br(), br(),br(),
                     
                     div(
                     tags$a(href="https://cran.r-project.org/web/packages/tidyquant/index.html","Powered by",
                              style = "padding-left:11px"),
                     tags$a(href="https://fred.stlouisfed.org/" ,"©"),
                     # tags$a(href="https://github.com/Aggarch/MQF-UAH" ,"*"),
                     
                     br(),
                  
                     tags$img(src='rstudio_logo_white.png', height=40, width=120, 
                              style = "padding-left:27px"),
                     tags$img(src='fred_white_2.png', height=40, width=40,
                              style= "padding-left:7px"),

                     )
                        )
                     # tags$blockquote("Andrés García & Sagith Amín"))
                 
                   

#home 



# 3.) home ####

  ),
  dashboardBody(
    tabItems(
      tabItem("home",
                     fluidPage(
                        column(12,
                               wellPanel(
                                 h1("Quantitative Market Analytics"), 
                                 # tags$a(href="https://github.com/Aggarch/MQF-UAH" ,"GitHub",
                                 #        style = "padding-left:7px"),
                                 
                                 hr(),
                                 helpText("**Lorem** ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit, 
                                  sapien quis convallis porttitor, nunc justo ultrices justo, ut laoreet nisl risus vitae nisl.
                                  Donec dictum risus at ipsum luctus varius. Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat tus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purus.      
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  ---
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purus.
                                  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit,
                                  sapien quis convallis porttitor, nunc justo ultrices justo, ut laoreet nisl risus vitae nisl.
                                  Donec dictum risus at ipsum luctus varius. Proin varius quam at congue posuere.",hr(),

                                  tags$img(src   = "data_science.png", width = "650px", height = "240px", 
                                           style = "width:720px;height:300px;display:block;margin:auto"),br(),
                                  tags$a(href="https://r4ds.had.co.nz/","R for Data Science"))
                                 
                                 )
                             )
                         )
                      ),
      


# 4.) description ####


      tabItem("description",
              fluidPage(
                column(4,
                       wellPanel(
                         h2("Descriptive Market Analytics"),
                         h2(
                         helpText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit
                                  sapien quis convallis porttitor, nunc justo ultrices justo, ut laoreet nisl risus vitae nisl.
                                  Donec dictum risus at ipsum luctus varius. Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purusat ipsum luctus varius. 
                                  Proin varius quam at congue posuere.",
                                  
                                  "ictum risus at ipsum luctus varius. Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purusat ipsum luctus varius. 
                                  Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, ege
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purus.")
                         ),
                         pickerInput(
                           inputId = "variable",
                           label = "Variables",
                           choices = market_list, multiple = TRUE
                         ),
                         textInput(inputId = "text", 
                                   label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange" , "Intervalo de fechas:" ,
                                          start   =  today()-365,
                                          end     =  today(),
                                          min     =  "2008-01-01",
                                          max     =  today()+ 365,
                                          separator = " - " ,
                                          startview = "year"),
                         actionButton(inputId = "observe", label = "Observe")
                       )
                ),
                column(8,
                       fluidPage(
                         wellPanel(
                           tabsetPanel(
                             tabPanel("Correlation Matrix", withSpinner(plotOutput("index_cor"),
                                                                        color="#0dc5c1")),
  
                             tabPanel("Rolling Correlation", withSpinner(plotlyOutput("rolling_cor"),
                                                                         color="#0dc5c1")), 
                             
                             tabPanel("Price Evolution", withSpinner(plotlyOutput("evolution"),
                                                                     color="#0dc5c1")),
                             
                             tabPanel("Price Returns", withSpinner(plotlyOutput("returns"),
                                                                   color="#0dc5c1"))

                           )
                         )
                         
                       )
                       
                )
              )
              
      ),


#prediction

# 5.) prescription ####


#prediction
      tabItem("prediction",
              fluidPage(
                column(4,
                       wellPanel(
                         h2("Predictive Market Analytics"),
                         helpText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit, 
                                  sapien quis convallis porttitor, nunc justo ultrices justo, ut laoreet nisl risus vitae nisl.
                                  Donec dictum risus at ipsum luctus varius. Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purus."),
                         pickerInput(
                           inputId = "variable",
                           label = "Variables",
                           choices = market_list, multiple = TRUE),
                         textInput(inputId = "text", 
                                   label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange" , "Intervalo de fechas:" ,
                                         start   =  today()-365,
                                         end     =  today(),
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         actionButton(inputId = "observe", label = "Observe")
                       )
                ),
                column(8,
                       fluidPage(
                         wellPanel(
                           tabsetPanel(
                             tabPanel("Time Series", withSpinner(plotOutput("forecast"),
                                                                        color="#0dc5c1")),

                             tabPanel("Trend Decomposition", withSpinner(plotlyOutput("trend"),
                                                                         color="#0dc5c1")),

                             tabPanel("Ts Changepoints", withSpinner(plotlyOutput("changepoints"),
                                                                     color="#0dc5c1"))
                             
                       
                           )
                         )
                         
                       )
                       
                )
              )
              
      ),


#prescription

# 6.) prescription ####

      tabItem("prescription",
              fluidPage(
                column(4,
                       wellPanel(
                         h2("Prescriptive Market Analytics"),
                         helpText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit, 
                                  sapien quis convallis porttitor, nunc justo ultrices justo, ut laoreet nisl risus vitae nisl.
                                  Donec dictum risus at ipsum luctus varius. Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purus."),
                         pickerInput(
                           inputId = "variable",
                           label = "Variables",
                           choices = market_list, multiple = TRUE
                         ),
                         textInput(inputId = "text", 
                                   label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange" , "Intervalo de fechas:" ,
                                         start   =  today()-365,
                                         end     =  today(),
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         actionButton(inputId = "observe", label = "Observe")
                       )
                ),
                column(8,
                       fluidPage(
                         wellPanel(
                           tabsetPanel(
                             tabPanel("Portfolios", withSpinner(plotOutput("portfolio"),
                                                                        color="#0dc5c1")),

                             tabPanel("All Weather", withSpinner(plotlyOutput("all_weather"),
                                                                         color="#0dc5c1")),

                             tabPanel("Recomendations", withSpinner(plotlyOutput("recomendations"),
                                                                     color="#0dc5c1")),

                             tabPanel("Mark to Market", withSpinner(plotlyOutput("m2m"),
                                                                   color="#0dc5c1"))
                          
                           )
                         )
                         
                       )
                       
                )
              )
              
      ),
      tabItem("comodities")
      
    )
  )
)

