

# 0.) ui ####
skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
  skin <- "black"


t <- "QuanTradeR"
# tags$span(style="color:white", "QuanTradeR",
# tags$a(href='',
#               icon("fort-awesome"))
# )


# 1.) dashboardPage ####
ui <- dashboardPage(
  dashboardHeader(title = t, titleWidth = 200, 
                  # dashboardHeader(title = span(tagList(icon("calendar"), "Example"))),
                  
                  tags$li(class="dropdown",tags$a(href="https://github.com/Aggarch/", 
                                                  icon("github","fa-2x"), "",
                                                  style= "padding-left:27px,width:550px;height:40px",
                                                  target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://www.teletrader.com/markets/world", 
                                                  icon("accusoft","fa-2x"), "",
                                                  style= "padding-left:27px,width:550px;height:40px",
                                                  target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://twitter.com/AndgTrader", 
                                                  icon("twitter","fa-2x"), "",
                                                  style= "padding-left:27px,width:550px;height:40px",
                                                  target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://www.bloomberg.com/live", 
                                                  icon("newspaper","fa-2x"), "",
                                                  style= "padding-left:27px,width:550px;height:40px",
                                                  target="_blank"))),
  dashboardSidebar(width = 200,
                   sidebarMenu(
                     menuItem("Presentation", tabName = "home", icon = icon("file-code   ")),
                     menuItem("Paradigm", tabName = "paradigm", icon = icon("info-circle"   )),
                     menuItem("DataFlow", tabName = "dflow", icon = icon("database"   )),
                     menuItem("FrameWork", tabName = "fwork", icon = icon("crop-alt"   )),
                     
                     menuItem("Sentiment", tabName = "sentiment", icon = icon("twitter   ")
                              # menuSubItem('Portfolio', tabName = 'portfolio', icon = icon("circle-notch")),
                              # menuSubItem('Notes', tabName = 'notes', icon = icon("circle-notch"))
                     ),
                     
                     menuItem("Description", tabName = "description", icon = icon("poll   ")
                              # menuSubItem('Macroeconomics', tabName = 'macroeconomics', icon = icon("circle-notch")),
                              # menuSubItem('Indexes', tabName = 'indexes',  icon = icon("circle-notch")),
                              # menuSubItem('Comodities', tabName = 'comodities',  icon = icon("circle-notch")),
                              # menuSubItem('Currencies', tabName = 'comodities',  icon = icon("circle-notch"))
                     ),
                     menuItem("Prediction", tabName = "prediction", icon = icon("project-diagram    ")
                              # menuSubItem('FedMeeting Matrix', tabName = 'fedmeetings', icon = icon("circle-notch")),
                              # menuSubItem('Time series', tabName = 'timeseries', icon = icon("circle-notch")),
                              # menuSubItem('Montecarlo', tabName = 'montecarlo', icon = icon("circle-notch"))
                     ),
                     menuItem("Prescription", tabName = "prescription", icon = icon("chart-line  ")
                              # menuSubItem('Risk & Rates', tabName = 'scenario', icon = icon("circle-notch"))
                              # menuSubItem('Notes', tabName = 'notes', icon = icon("circle-notch"))
                     ),
                     
                     br(), br(),br(),br(),br(),  
                     br(), br(),
                     
                     div(
                       tags$a(href="https://cran.r-project.org/web/packages/tidyquant/index.html","Powered by",
                              style = "padding-left:50px,width:2px;height:2px"),
                       tags$a(href="https://fred.stlouisfed.org/" ,"©"),
                       
                       br(),
                       
                       tags$img(src='rstudio_logo_white.png', height=20, width=80, 
                                style = "padding-left:29px"),
                       tags$img(src='fred_white_2.png', height=25, width=25,
                                style= "padding-left:7px")
                       
                     )
                   )
                   
                   
                   
                   
                   # 3.) home ####
                   
  ),
  dashboardBody(
    tabItems(
      tabItem("home",
              fluidPage(
                column(12,
                       wellPanel(
                         h2("Quantitative Market Analytics"), 
                         # tags$a(href="https://github.com/Aggarch/MQF-UAH" ,"GitHub",
                         #        style = "padding-left:7px"),
                         
                         hr(),
                         h5(
                           helpText(
                             # div(style="text-align:center",
                             div( div(style="text-align:center",
                                      
                                      "Uncertainty is a constant, Data-driven decision making, inspired in business knowledge and behaviour, contribute to performance",br(),
                                      "The challenge is to close the gap between the quantitative and the qualitative and reduce markets complexity using Data Science, ",br(),
                                      
                                      
                                      "Variables you can interact with in this tool belongs to four cathegories:  Macroeconomics, Commodities, Equity-Indices & Currencies.", br(),
                                      
                                      "NOTE: This R web-app is the result of an academic research, more variables can be included as well to respond more specific needs.", br(),
                                      br(),br(),br(),br(),
                                      
                                      tags$img(src   = "https://wwwen.uni.lu/var/storage/images/media/images/data_science_explore/1136248-1-fre-FR/data_science_explore.png", 
                                               width = "500px", height = "200px", 
                                               style = "width:390px;height:150px;display:block;margin:auto"),br(),
                                      tags$a(href="https://r4ds.had.co.nz/explore-intro.html","R for Data Science"))
                                  
                             )
                           )
                           
                         )
                       ) 
                )
              )
      ),
      tabItem("paradigm",
              fluidPage(
                column(12,
                       wellPanel(
                         h3("Decision Intelligence"), 
                         tags$a(href="https://en.wikipedia.org/wiki/Decision_intelligence" ,"The Discipline of Decision Intelligence",
                                style = "padding-left:7px;height:350px"),
                         
                         hr(),br(),
                         h4(
                           helpText("",
                                    
                                    tags$img(src= "https://upload.wikimedia.org/wikipedia/commons/3/3c/DEFramework.png",
                                             style ="width:500px;height:300px;display:block;margin:auto"))
                         ),br(),
                       )
                )
              )
      ),
      
      tabItem("dflow",
              fluidPage(
                column(12,
                       wellPanel(
                         h3("Business & DataFlow"), 
                         tags$a(href="https://es.wikipedia.org/wiki/Cross_Industry_Standard_Process_for_Data_Mining" ,"CRISP-DM",
                                style = "padding-left:7px"),
                         
                         hr(),
                         h4(
                           helpText("",
                                    
                                    tags$img(src= "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/CRISP-DM_Process_Diagram.png/800px-CRISP-DM_Process_Diagram.png", 
                                             style ="width:340px;height:340px;display:block;margin:auto"))
                         ),br(),
                       )
                )
              )
      ),
      tabItem("fwork",
              fluidPage(
                column(12,
                       wellPanel(
                         h3("Analytics Framework"), 
                         tags$a(href="https://pubsonline.informs.org/doi/pdf/10.1287/opre.38.1.7" ,"Analytics",
                                style = "padding-left:7px"),
                         
                         hr(),
                         h4(
                           helpText("",
                                    
                                    tags$img(src= "https://www.gurobi.com/wp-content/uploads/2018/12/analytic-types-chart.png",
                                             style ="width:580px;height:380px;display:block;margin:auto"))
                         ),
                       )
                )
              )
      ),
      
      
      
      
      # 4.) description ####
      
      
      tabItem("description",
              fluidPage(
                useShinyalert(),
                column(3,
                       wellPanel(
                         h3("Descriptive Analytics"),
                         
                         h5( 
                           helpText( "¿What Happened and Why?" , br(),br(),
                                     "Central and deviation measures, distributions of frequency and others descriptions, tells the what,
                                    The why it's a Story-Telling, interpretation based.
                                    Coronavirus data on www.who.int."
                           )
                         ),
                         
                         pickerInput(
                           inputId = "variable",
                           label = "Variables",
                           choices = market_list,
                           selected = "SP500",
                           multiple = T
                           
                         ),
                         
                         dateRangeInput ("daterange" , "Date Interval:" ,
                                         start   =  today()-365,
                                         end     =  today(),
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         actionButton(inputId = "observe", label = "Describe",
                                      icon = icon('chart-bar'),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(9,
                       fluidPage(
                         wellPanel(
                           tabsetPanel(
                             
                             tabPanel("Covid-19", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("TreeMap ", withSpinner( plotlyOutput("treemap",height = "380px"), color = "#1da1f2" )),         
                                              tabPanel("Density ", withSpinner( plotlyOutput("density", height = "380px"), color="#1da1f2"))
                                      )),
                             
                             tabPanel("Price", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Behaviour", withSpinner( plotlyOutput("evolution",height = "380px"), color = "#1da1f2" )),         
                                              tabPanel("Summary of Monthly Log-Returns", withSpinner( reactableOutput("summary"), color="#1da1f2"))
                                              
                                      )),
                             
                             
                             tabPanel("Returns", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Daily", withSpinner( plotlyOutput("returns_d",height = "380px"), color = "#1da1f2")),         
                                              tabPanel("Weekly", withSpinner( plotlyOutput("returns_w", height = "380px"), color="#1da1f2")),
                                              tabPanel("Monthly", withSpinner( plotlyOutput("returns_m", height = "380px"), color="#1da1f2")),
                                              tabPanel("Yearly", withSpinner( plotlyOutput("returns_y", height = "380px"), color="#1da1f2"))
                                              
                                              
                                      )),
                             
                             tabPanel("Rolling Volatility", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("DoD% 1m W", withSpinner(plotlyOutput("roll_vol_one",height = "380px"), color = "#1da1f2" )),         
                                              tabPanel("DoD% 3m W", withSpinner(plotlyOutput("roll_vol_three",height = "380px"), color = "#1da1f2" )),
                                              tabPanel("DoD% 6m W", withSpinner(plotlyOutput("roll_vol_six",height = "380px"), color = "#1da1f2" )),
                                              
                                              tabPanel("MoM% 1m W", withSpinner(plotlyOutput("rollm_vol_one",height = "380px"), color = "#1da1f2" )),         
                                              tabPanel("MoM% 3m W", withSpinner(plotlyOutput("rollm_vol_three",height = "380px"), color = "#1da1f2" )),
                                              tabPanel("MoM% 6m W", withSpinner(plotlyOutput("rollm_vol_six",height = "380px"), color = "#1da1f2" ))
                                              
                                              
                                              
                                      )),
                             
                             
                             tabPanel("VaR & CVaR", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("99%", withSpinner( plotlyOutput("vars_99", height = "400px"), color="#1da1f2")),
                                              tabPanel("95%", withSpinner( plotlyOutput("vars_95",height  = "400px"), color="#1da1f2")),         
                                              tabPanel("90%", withSpinner( plotlyOutput("vars_90", height = "400px"), color="#1da1f2")),
                                              tabPanel("85%", withSpinner( plotlyOutput("vars_85", height = "400px"), color="#1da1f2")),
                                              tabPanel("80%", withSpinner( plotlyOutput("vars_80", height = "400px"), color="#1da1f2"))
                                              
                                              
                                      )),
                             
                             
                             tabPanel("Corr Matrix", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Daily", withSpinner(plotOutput("index_cor_d",height = "300px"),color="#1da1f2")),
                                              tabPanel("Monthly", withSpinner(plotOutput("index_cor_m",height = "300px"),color="#1da1f2")),
                                              tabPanel("Yearly", withSpinner(plotOutput("index_cor_y",height = "300px"),color="#1da1f2"))
                                              
                                      )),
                             
                             tabPanel("Rolling Corr", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Weekly", withSpinner(plotlyOutput("rolling_cor_w",height = "300px"),color="#1da1f2")),
                                              tabPanel("Monthly", withSpinner(plotlyOutput("rolling_cor_m",height = "300px"),color="#1da1f2"))
                                              
                                              
                                      ))
                             
                           )
                         )
                         
                       )
                       
                )
              )
              
      ),
      
      
      #prediction
      
      # 5.) prediction ####
      
      
      #prediction
      tabItem("prediction",
              fluidPage(
                useShinyalert(),
                column(3,
                       wellPanel(
                         h3("Predictive Analytics"),
                         helpText("¿What Might Happen?" , br(),br(),
                                  
                                  "The time series isolate the components, combines them efficiently to 
                                  predict a range of values with the main aspects of the price.", 
                                  
                                  
                         ),
                         pickerInput(
                           inputId = "variable_1",
                           label = "Variables",
                           selected = "SP500",
                           choices = market_list[2:4],
                           multiple = F),
                         
                         # textInput(inputId = "text", 
                         #           label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange_1" , "Date Interval:" ,
                                         start   =  today()-1500,
                                         end     =  today(),
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         
                         actionButton(inputId = "observe_1", label = "Forecast",
                                      icon = icon('money-bill-wave'),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(9,
                       fluidPage( 
                         wellPanel(
                           tabsetPanel(
                             
                             tabPanel("tS Concept", br(),br(),br(),
                                      tags$img(src= "comps.jpg",
                                               style = "padding-left:7px;width:600px;height:200px;display:block;margin:auto")),
                             
                             
                             
                             # tabPanel("Asset TS", withSpinner(plotlyOutput("fcast",height = "600px"),
                             #                                  color="#1da1f2")),
                             
                             tabPanel("Asset tS", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Forecast", withSpinner( plotlyOutput("fcast",height = "380px"), color = "#1da1f2")),         
                                              tabPanel("P Metrics", withSpinner( gt_output("performance"), color="#1da1f2")),
                                              tabPanel("Cross Validation", withSpinner( plotlyOutput("crossv", height = "380px"), color="#1da1f2"))
                                              
                                      )),
                             
                             
                             # tabPanel("TS Returns", withSpinner(plotlyOutput("tsr",height = "380px"), color="#1da1f2")),
                             tabPanel("Trend Decomp", withSpinner(plotOutput("trend",height = "380px"), color="#1da1f2")),
                             tabPanel("Daypoints", withSpinner(dataTableOutput("changep",height = "380px"),color="#1da1f2"),
                                      boton_descarga("down", "Forecast")),
                             tabPanel("GARCH Vol", withSpinner(plotlyOutput("garch_mod",height = "380px"), color="#1da1f2")),
                             tabPanel("GARCH Forecast", withSpinner(plotlyOutput("vol_forecast",height = "380px"), color="#1da1f2"))
                             
                             
                             
                             
                             
                             
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
                column(3,
                       wellPanel(
                         h3("Prescriptive Analytics"),
                         helpText("¿What Should We Do?" , br(),br(),
                                  
                                  
                                  "Uncertainty Measurement & Monetary Policy are key examples of valuable 
                                  information that might be consider as exogenous and impact forecast."
                                  
                                  
                         ),
                         pickerInput(
                           inputId = "variable_2",
                           label = "Variables",
                           choices = market_list, 
                           selected = "SP500",
                           multiple = F
                         ), 
                         # textInput(inputId = "text", 
                         #           label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange_2" , "Date Interval:" ,
                                         start   =  today()-365,
                                         end     =  today(),
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         actionButton(inputId = "observe_2", label = "Diagnose", 
                                      icon = icon("search-dollar"),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(9,
                       
                       wellPanel(
                         fluidPage(
                           tabsetPanel(
                             
                             tabPanel("Scenario", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("FED Rates vs Risk", withSpinner( plotlyOutput("rates_risk",height = "380px"), color = "#1da1f2" )),         
                                              tabPanel("EPU year summary", withSpinner( plotlyOutput("epu_abst", height = "380px"), color="#1da1f2")),
                                              tabPanel("EFFR & Futures", withSpinner( reactableOutput("fed_data", height = "380px"), color="#1da1f2")),
                                              tabPanel("EPU table", withSpinner( reactableOutput("epu_data"), color="#1da1f2"))
                                              
                                              
                                      )
                             ),
                             
                             tabPanel("Recomendations", 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Neural Network", withSpinner( plotOutput("ts_nnet_pred", height = "380px"),color="#1da1f2")),
                                              tabPanel("Network Posible Future", withSpinner( reactableOutput("ts_nnet_pred_tbl"),color="#1da1f2"))
                                              
                                              
                                              
                                      )
                             ),
                             
                             # tabPanel("Mark to Market", withSpinner(plotlyOutput("m2m",height = "600px"),
                             #                                        color="#1da1f2"))
                             
                             
                             tabPanel("Mark to Market Management",br(),br(),
                                      # tags$img(src= "m2m.png",
                                      #          style = "padding-left:7px;width:570px;height:400px;display:block;margin:auto"), br(),
                                      tags$a(href="https://www.myfxbook.com/members/andresga/andresgarciadcgmailcom/6639617/Rnw5ctS8zsiRhllVSaLK",
                                             "Explore more about a M2Market Management Strategy",
                                             style = "padding-left:11px"))
                             
                             
                           )
                         )
                         
                         
                       )
                       
                )
              )
              
      ),
      
      tabItem("sentiment",
              fluidPage(
                useShinyalert(),
                column(3,
                       wellPanel(
                         h3("Market Sentiment"),
                         
                         h5( 
                           helpText("¿How does people feel about risk?" , br(),br(),
                                    
                                    "Minimalistic example of market sentiment analysis."),
                         ),
                         
                         
                         textInput(inputId ="hashtag", 
                                   label = h3("#Hashtag"), value = "recession" ) ,  ####
                         
                         
                         actionButton(inputId = "observer",
                                      label = "Feel", 
                                      icon = icon('comments-dollar'),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(9,
                       fluidPage(
                         wellPanel(
                           tabsetPanel(
                             
                             tabPanel("Google Trends", withSpinner(plotlyOutput("google_trends",height = "450px"),
                                                                   color="#1da1f2")),
                             
                             tabPanel("Newspapers", withSpinner(dataTableOutput("news_",height = "450px"),
                                                                color="#1da1f2")),
                             
                             tabPanel("Frequency Charts", withSpinner(plotlyOutput("freq_",height = "450px"),
                                                                      color="#1da1f2")),
                             
                             tabPanel("Sentiment", withSpinner(dataTableOutput("hashtag_",height = "450px"),
                                                               color="#1da1f2"))
                             
                             # tabPanel("Correlation Matrix", withSpinner(plotOutput("index_cor",height = "600px"),
                             #                                            color="#1da1f2"))
                             
                             
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

