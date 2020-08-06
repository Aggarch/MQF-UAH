

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
  dashboardHeader(title = t, titleWidth = 250, 
                  # dashboardHeader(title = span(tagList(icon("calendar"), "Example"))),
                  
                  tags$li(class="dropdown",tags$a(href="https://github.com/Aggarch/", 
                                                  icon("github","fa-2x"), "",
                                                  style= "padding-left:27px,width:650px;height:40px",
                                                  target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://www.teletrader.com/markets/world", 
                                                  icon("accusoft","fa-2x"), "",
                                                  style= "padding-left:27px,width:650px;height:40px",
                                                  target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://twitter.com/AndgTrader", 
                                                  icon("twitter","fa-2x"), "",
                                                  style= "padding-left:27px,width:650px;height:40px",
                                                  target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://www.bloomberg.com/live", 
                                                  icon("newspaper","fa-2x"), "",
                                                  style= "padding-left:27px,width:650px;height:40px",
                                                  target="_blank"))),
  dashboardSidebar(width = 250,
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
                             
                     ),
                     menuItem("Prediction", tabName = "prediction", icon = icon("project-diagram    ")
                              # menuSubItem('FedMeeting Matrix', tabName = 'fedmeetings', icon = icon("circle-notch")),
                              # menuSubItem('Montecarlo', tabName = 'montecarlo', icon = icon("circle-notch"))
                     ),
                     menuItem("Prescription", tabName = "prescription", icon = icon("chart-line  ")
                              # menuSubItem('Risk & Rates', tabName = 'scenario', icon = icon("circle-notch"))
                              # menuSubItem('Notes', tabName = 'notes', icon = icon("circle-notch"))
                     ),
                     
                     br(), br(),br(),br(),br(),  br(), br(),br(),br(),br(),
                     br(), br(),br(),br(),br(),  br(), br(),br(),br(),br(),
                     br(), 
                     
                     div(
                       tags$a(href="https://cran.r-project.org/web/packages/tidyquant/index.html","Powered by",
                              style = "padding-left:11px"),
                       tags$a(href="https://fred.stlouisfed.org/" ,"©"),
                       # tags$a(href="https://github.com/Aggarch/MQF-UAH" ,"*"),
                       
                       br(),
                       
                       tags$img(src='rstudio_logo_white.png', height=40, width=120, 
                                style = "padding-left:27px"),
                       tags$img(src='fred_white_2.png', height=40, width=40,
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
                         h1("Quantitative Market Analytics"), 
                         # tags$a(href="https://github.com/Aggarch/MQF-UAH" ,"GitHub",
                         #        style = "padding-left:7px"),
                         
                         hr(),
                         h3(
                           helpText("In the context of Quantitative Finance, specifically the field of Market Risk, the uncertainty is a constant.
                                     This initiative takes into consideration the paradigm of Decision Intelligence, understanding this concept as the discipline of decision making,
                                     inspired in data, business knowledge and behavior.
                                     This discipline, also known as decision engineering, tries to close the gap between quantitative and qualitative elements.
                                     It is important to understand this exercise as a dynamic analysis, and to bear in mind that markets are very complex and therefore
                                     the purpose of this tool is to reinforce the expert’s decision-making process. 
                                     The Financial Trader will incorporate to the process, or strategy, a set of different dimensions or variables that might have significant
                                     impact in the execution, or market analysis.
                                     The variables shared in this exercise belong to 4 different categories of the market risk;
                                     Macroeconomics, Commodities, Equity Indexes & Currencies.",         br(),
                                    
                                    
                                    "The information for the analysis considers macroeconomics from the United States.
                                    The user can interact with different variables in different time frames to find insights that might guide market decisions,
                                    market understanding or at least a data-driven observation. This is the masterpiece for the incubation of intuition.", br(), 
                                    
                                    "NOTE: This is the result of an academic research, more variables can be included to respond to more specific needs." , br(),br(),br(),
                                    
                                    tags$img(src   = "https://wwwen.uni.lu/var/storage/images/media/images/data_science_explore/1136248-1-fre-FR/data_science_explore.png", 
                                             width = "450px", height = "180px", 
                                             style = "width:620px;height:250px;display:block;margin:auto"),br(),
                                    tags$a(href="https://r4ds.had.co.nz/explore-intro.html","R for Data Science"))
                           
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
                                style = "padding-left:7px;height:550px"),
                         
                         hr(),br(),br(),
                         h4(
                           helpText("",
                                    
                                    tags$img(src= "https://upload.wikimedia.org/wikipedia/commons/3/3c/DEFramework.png",
                                             style ="width:800px;height:450px;display:block;margin:auto"))
                         ),br(),br()
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
                         
                         hr(),br(),br(),
                         h4(
                           helpText("",
                                    
                                    tags$img(src= "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/CRISP-DM_Process_Diagram.png/800px-CRISP-DM_Process_Diagram.png", 
                                             style ="width:550px;height:550px;display:block;margin:auto"))
                         ),br(),br()
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
                         
                         hr(),br(),br(),
                         h4(
                           helpText("",
                                    
                                    tags$img(src= "https://www.gurobi.com/wp-content/uploads/2018/12/analytic-types-chart.png",
                                             style ="width:900px;height:500px;display:block;margin:auto"))
                         ),br(),br(),
                       )
                )
              )
      ),
      

      
      # 4.) description ####
      
      
      tabItem("description",
              fluidPage(
                useShinyalert(),
                column(4,
                       wellPanel(
                         h2("Descriptive Market Analytics"),
                         
                         helpText("¿What Happened and Why?" , br(),
                                  "Statistically knowing what happened, it's 'easy' because we are able to calculate central or deviation measures, distributions of frequency, etc,
                                  but conecting the dots between what happened and why, it's a Story-Telling activity, product of human understanding and representations of reality.",br(),
                                  
                                  
                                  "In this area we can select a variable, probably an asset of the prefered asset class, or the Economic Policy Uncertainty Index, to observe how does the 
                                  uncertainty evolves in a specific time range, the time range it's analyst election, maybe a date range linked to an specific event.", br(),
                                  
                                  "After selecting the variable and timeframe of interest, we can observe the price evolution and checkout the dots density across time, dancing around a simple smoothed linear model,
                                  the election can be translated to the logarithmic returns, this migth provide an intuition of performance, then it may be interesting to observe how do different 
                                  variables liearly correlate each other, and by the end, take a look to the dinamyc correlation of the selection against the Dollar Index spot, 'US dollar Strenght'.", br(),
                                  
                                  "Data about the Coronavirus distribution and density are available in WHO webpage, this is a Global event important to be considered in this context, since
                                  directly affects humans health and economies, principal drivers of productivity, performance and wealth."),
                         
                         
                         pickerInput(
                           inputId = "variable",
                           label = "Variables",
                           choices = market_list,
                           selected = "SP500",
                           multiple = TRUE
                           
                         ),
                         # textInput(inputId = "text", 
                         #           label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange" , "Date Interval:" ,
                                         start   =  today()-365,
                                         end     =  today()-1,
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         actionButton(inputId = "observe", label = "Describe",
                                      icon = icon('chart-bar'),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(8,
                       fluidPage(
                         wellPanel(
                           tabsetPanel(
                             
                             tabPanel("Macro Events (Covid-19)", br(), 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("TreeMap ", withSpinner( plotlyOutput("treemap",height = "500px"), color = "#1da1f2" )),         
                                              tabPanel("Density ", withSpinner( plotlyOutput("density", height = "500px"), color="#1da1f2"))
                                      )),
                             
                             tabPanel("Price Evolution", br(),
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Asset Behaviour", withSpinner( plotlyOutput("evolution",height = "500px"), color = "#1da1f2" )),         
                                              tabPanel("Summary of Data", withSpinner( reactableOutput("summary"), color="#1da1f2"))
                                      )),
                                              
                             
                             tabPanel("Price Returns", br(), 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Daily", withSpinner( plotlyOutput("returns_d",height = "600px"), color = "#1da1f2")),         
                                              tabPanel("Weekly", withSpinner( plotlyOutput("returns_w", height = "600px"), color="#1da1f2")),
                                              tabPanel("Monthly", withSpinner( plotlyOutput("returns_m", height = "600px"), color="#1da1f2")),
                                              tabPanel("Yearly", withSpinner( plotlyOutput("returns_y", height = "600px"), color="#1da1f2"))
                                              
                                              
                                      )),
                             
                             
                             # tabPanel("Price Returns", withSpinner(plotlyOutput("returns",height = "600px"),
                             #                                            color="#1da1f2")),
                             
                             tabPanel("Correlation Matrix", withSpinner(plotOutput("index_cor",height = "600px"),
                                                                        color="#1da1f2")),
                             
                             tabPanel("Rolling Correlation", withSpinner(plotlyOutput("rolling_cor",height = "600px"),
                                                                         color="#1da1f2"))
                             
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
                column(4,
                       wellPanel(
                         h2("Predictive Market Analytics"),
                         helpText("¿What Might Happen?" , br(),
                                  
                                  
                                  "To have a good notion of where the price might be, it's important to know where is it now and how it moves, in this panel, it's the same dinamyc, we select a variable and a date range,
                                  then we push the 'Forecast button', and the algorithm calculate a time series model, time series have 3 principal components.",br(),
                                  
                                  "Trend, Seasonality and Noise or randomness.", br(), 
                                  
                                  "Basically the time series model and analysis decompose the time series, understanding a time series as a succession of observations in time, so a time series it's a long 
                                  table with 2 columns, date and price in this case. The analysis of the time series isolate the components of the time series selected, and combines them in 3 possible ways,
                                  by addition, multiplication or a combination of both, the algorithm used, transform the data and makes the decomposition and recomposition in the best possible way in order to 
                                  predict a range of possible values that incorporate the prevalent aspects of the components mentioned.", br(),
                                  
                                  "This approach and method is very popular in financial forecasting, the model do not incorporate information distinct that the date and price,
                                  exogenous information it's not legible for the model so this approach can and will be enrich a posteriori in the prescription module. The time series forecasting and methology, 
                                  enjoy of a good reputation in financial sector as an statistic approach to forecast."

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
                                         end     =  today()-1,
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         
                         actionButton(inputId = "observe_1", label = "Forecast",
                                      icon = icon('money-bill-wave'),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(8,
                       fluidPage( 
                         wellPanel(
                           tabsetPanel(
                             
                             tabPanel("Time Series Concept", br(),br(),br(),
                                      tags$img(src= "comps.jpg",
                                               style = "padding-left:7px;width:600px;height:200px;display:block;margin:auto")),
                             
                             
                             
                             # tabPanel("Asset TS", withSpinner(plotlyOutput("fcast",height = "600px"),
                             #                                  color="#1da1f2")),
                             
                             tabPanel("Asset TS", br(), 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Forecast", withSpinner( plotlyOutput("fcast",height = "600px"), color = "#1da1f2")),         
                                              tabPanel("P Metrics", withSpinner( gt_output("performance"), color="#1da1f2")),
                                              tabPanel("Cross Validation", withSpinner( plotlyOutput("crossv", height = "600px"), color="#1da1f2"))
                                              
                                      )),
                             
                             
                             tabPanel("TS Returns", withSpinner(plotlyOutput("tsr",height = "600px"), color="#1da1f2")),
                             tabPanel("Trend Decomposition", withSpinner(plotOutput("trend",height = "600px"), color="#1da1f2")),
                             tabPanel("TS Daypoints", withSpinner(dataTableOutput("changep",height = "600px"),color="#1da1f2"),
                                      boton_descarga("down", "Forecast"))
                             
                             
                             
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
                         helpText("¿What Should We Do?" , br(),
                                  
                                  
                                  "Considering the result of the time series forecast, and the expertise of the analyst or trader, we can explore the behavior of main financial markets drivers, 
                                  to make a forecast able to icorporate exogenous information, understanding exogenous information as data that do not directly correspond to the time series.",br(),
                                  
                                  "Uncertainty Measurement & Monetary Policy are key examples of valuable information that might be consider as 'exogenous'.", br(), 
                                  
                                  "This panel select the variable of interest, calculate the future of the timeseries and EPU (Economic Policy Uncertainty Index), and assume that the FED Policy Stategy and market expectations 
                                  about FED possible actions remains constant. Then a Regression Neural Network, study the data available in a dataset containing this information structure about the past, and predict the future, 
                                  so now we have 3 Forecast outputs for the asset.", br(),
                                  
                                  "ASSET : The real life price when the market closure was effective, otherwise the time series prediction.", br(),
                                  "INDEX : The real life Economic Policy Uncertainty Index in case it was released, otherwise the time series prediction.", br(),
                                  "PRED.nnet : The Neural Network prediction considering the INDEX, and the FED Funds rates & futures.",br(),
                                  "W.Forecast: Neural Network prediction weigthed by the Uncertainty Level,the main idea of this measure it's to increase sensibility about uncertainty."
                                  
                                  
                                  
                         ),
                         pickerInput(
                           inputId = "variable_2",
                           label = "Variables",
                           choices = market_list, 
                           selected = "SP500",
                           multiple = TRUE
                         ), 
                         # textInput(inputId = "text", 
                         #           label = "Stock Ticker", value = "Enter text..."),  ####
                         
                         dateRangeInput ("daterange_2" , "Date Interval:" ,
                                         start   =  today()-365,
                                         end     =  today()-1,
                                         min     =  "2008-01-01",
                                         max     =  today()+ 365,
                                         separator = " - " ,
                                         startview = "year"),
                         actionButton(inputId = "observe_2", label = "Diagnose", 
                                      icon = icon("search-dollar"),
                                      style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                       )
                ),
                column(8,
                       
                       wellPanel(
                         fluidPage(
                           tabsetPanel(
                             
                             tabPanel("Scenario", br(), 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("FED Rates vs Risk", withSpinner( plotlyOutput("rates_risk",height = "500px"), color = "#1da1f2" )),         
                                              tabPanel("EPU Current year summary", withSpinner( plotlyOutput("epu_abst", height = "500px"), color="#1da1f2")),
                                              tabPanel("FED Effective Rates & Futures", withSpinner( reactableOutput("fed_data", height = "500px"), color="#1da1f2")),
                                              tabPanel("EPU detailed table", withSpinner( reactableOutput("epu_data"), color="#1da1f2"))
                                              
                                              
                                      )
                             ),
                             
                             tabPanel("Recomendations", br(), 
                                      
                                      tabBox( side = "left", width = 13,
                                              tabPanel("Neural Network", withSpinner( plotOutput("ts_nnet_pred", height = "480px"),color="#1da1f2")),
                                              tabPanel("Network Posible Future", withSpinner( reactableOutput("ts_nnet_pred_tbl"),color="#1da1f2"))
                                              
                                              
                                              
                                      )
                             ),
                             
                             # tabPanel("Mark to Market", withSpinner(plotlyOutput("m2m",height = "600px"),
                             #                                        color="#1da1f2"))
                             
                             
                             tabPanel("Mark to Market Management", br(),br(),
                                      tags$img(src= "m2m.png",
                                               style = "padding-left:7px;width:850px;height:600px;display:block;margin:auto"), br(),
                                      tags$a(href="http://www.myfxbook.com/members/TraderHub/financialaboratorygmailcom/3984258/4ob5N1cxNCsZa8nHKF53",
                                             "Explore more details about a M2Market Management Strategy",
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
                         h2("Market Sentiment"),
                         
                         helpText("¿How does people feel about markets and risk?" , br(),
                                  " Answer to this question it's not easy, and requires to build more specific questions about what is sentiment and what
                                  do we really need to know, in the context of quantitative finance, this information may contribute to asset valuation,
                                  specially to the read of market expectation, the human tends to share feels and thoughts, feels and thoughts guide actions, so 
                                  probably knowing a little bit more about what do the people think about the market it's valuable.",br(),
                                  
                                  "In this Area we can look for specific tweets matching a #Hasthag, checkout whats the frecuency of searches  about a word 
                                  linked to market behaviour, for example 'recession', on Google Trends, but also on Twitter.", br(),
                                  
                                  "It's important to understand that this is a minimalistic example of market sentiment analysis, this technique can be 
                                  very sofisticated, complex and insightful."),
                         
                         # pickerInput(
                         #   inputId = "variable",
                         #   label = "Variables",
                         #   choices = market_list,
                         #   multiple = TRUE,
                         #   selected = "SP500"
                         #   
                         # ),
                         textInput(inputId ="hashtag", 
                                   label = h2("#Hashtag"), value = "recession" ) ,  ####
                         
                         #   dateRangeInput ("daterange" , "Date Interval:" ,
                         #                   start   =  today()-365,
                         #                   end     =  today(),
                         #                   min     =  "2008-01-01",
                         #                   max     =  today()+ 365,
                         #                   separator = " - " ,
                         #                   startview = "year"),
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
                             
                             tabPanel("Google Trends", withSpinner(plotlyOutput("google_trends",height = "600px"),
                                                                   color="#1da1f2")),
                             
                             tabPanel("Newspapers", withSpinner(dataTableOutput("news",height = "600px"),
                                                                color="#1da1f2")),
                             
                             tabPanel("Frequency Charts", withSpinner(plotlyOutput("freq",height = "600px"),
                                                                      color="#1da1f2")),
                             
                             tabPanel("Sentiment", withSpinner(dataTableOutput("hashtag",height = "600px"),
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
