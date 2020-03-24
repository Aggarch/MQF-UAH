## UI
skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
  skin <- "black"


ui <- dashboardPage(
  dashboardHeader(title = "quantApp"),
  dashboardSidebar(width = 272,
                   sidebarMenu(
                     menuItem("Home", tabName = "home", icon = icon("home")),
                     menuItem("Description", tabName = "description", icon = icon("poll")
                              # menuSubItem('Macroeconomics', tabName = 'macroeconomics', icon = icon("circle-notch")),
                              # menuSubItem('Indexes', tabName = 'indexes',  icon = icon("circle-notch")),
                              # menuSubItem('Comodities', tabName = 'comodities',  icon = icon("circle-notch")),
                              # menuSubItem('Currencies', tabName = 'comodities',  icon = icon("circle-notch"))
                     ),
                     menuItem("Prediction", tabName = "prediction", icon = icon("project-diagram"),
                              menuSubItem('FedMeeting Matrix', tabName = 'fedmeetings', icon = icon("circle-notch")),
                              menuSubItem('Time series', tabName = 'timeseries', icon = icon("circle-notch")),
                              menuSubItem('Montecarlo', tabName = 'montecarlo', icon = icon("circle-notch"))
                     ),
                     menuItem("Prescription", tabName = "prescription", icon = icon("chart-line"),
                              menuSubItem('Portfolio', tabName = 'portfolio', icon = icon("circle-notch")),
                              menuSubItem('Notes', tabName = 'notes', icon = icon("circle-notch"))
                     )
                   )
                   
  ),
  dashboardBody(
    tabItems(
      tabItem("description",
              fluidPage(
                column(4,
                       wellPanel(
                         h2("Market Analytics"),
                         helpText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit, 
                                  sapien quis convallis porttitor, nunc justo ultrices justo, ut laoreet nisl risus vitae nisl.
                                  Donec dictum risus at ipsum luctus varius. Proin varius quam at congue posuere. 
                                  Fusce fringilla tellus pretium, egestas lorem at, volutpat leo.
                                  Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                  Proin leo tortor, pulvinar non massa commodo, tempus vulputate purus."),
                         pickerInput(
                           inputId = "variable",
                           label = "Variables",
                           choices = list(
                             Macroeconomics = c("Global GDP"          = "NYGDPPCAPKDWLD",
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
                             Indexes = c("Standard & Poors 500" = "SP500",
                                         "Dow Jones"            = "DJIA",
                                         "Nasdaq Composite"     = "NASDAQCOM",
                                         "Nikkei"               = "NIKKEI225",
                                         "VIX"                  = "VIXCLS"),
                             Commodities = c("WTI"              = "WTISPLC",
                                             "Brent"            = "POILBREUSDM",
                                             "Gold"             = "GOLDAMGBD228NLBM",
                                             "Aluminium"        = "PALUMUSDM",
                                             "Corn"             = "PMAIZMTUSDM",
                                             "Soy"              = "PSOYBUSDQ"),
                             Currencies = c("DXY_CUR" = "DTWEXAFEGS",
                                            "EUR_USD" = "DEXUSEU",
                                            "GBP_USD" = "DEXUSUK",
                                            "USD_JPY" = "DEXJPUS",
                                            "USD_CAD" = "DEXCAUS",
                                            "AUD_USD" = "DEXUSAL",
                                            "USD_CHF" = "DEXSZUS",
                                            "USD_SEK" = "DEXSDUS"
                                            )
                           ),
                           multiple = TRUE
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
                             
                             # tabPanel("Technical Analysis", withSpinner(plotlyOutput("tech"),
                             #                                           color="#0dc5c1"))
                             # tabPanel("Price variation", dataTableOutput("table")),
                             # tabPanel("Technical analysis", dataTableOutput("table"))
                           )
                         )
                         
                       )
                       
                )
              )
              
      ),
      tabItem("indexes"),
      tabItem("comodities")
    )
  )
)
