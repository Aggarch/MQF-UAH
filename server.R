

#  ( A-Z ) Server ####

shinyServer(function(input, output) {
  
  
   # A) Reactive Expressions ####
  
  #description
  # Correlation Matrix
  index_cor <- eventReactive(input$observe, {
    
    behavior_data <- tq_get(input$variable, get = "economic.data",
                            from = input$daterange[1],
                            to = input$daterange[2]
    )
    
    {
      #   behavior_data %>%
      #
      #   Macroeconomics = c("Global GDP"          = "NYGDPPCAPKDWLD",
      #                      "Economic Policy Risk"         = "USEPUINDXD",
      #                      "Global Economic Uncertainty"  = "GEPUPPP",
      #                      "Trade Policy Risk"            = "CHNMAINLANDTPU",
      #                      "Houses Month supply"          = "MSACSR",
      #                      "CPI"                          = "CPIAUCSL",
      #                      "Real GDP"                     = "A191RL1Q225SBEA",
      #                      "IPI"                          = "INDPRO",
      #                      "Non Farm Payrolls"            = "PAYEMS",
      #                      "Unemployment Rate"            = "UNRATE",
      #                      "Treasury 10y"                 = "DGS10",
      #                      "Treasury 2y"                  = "GS2",
      #                      "FED Interest Rate"            = "FEDFUNDS"),
      #   Indexes = c("Standard & Poors 500" = "SP500",
      #               "Dow Jones"            = "DJIA",
      #               "Nasdaq Composite"     = "NASDAQCOM",
      #               "Nikkei"               = "NIKKEI225",
      #               "VIX"                  = "VIXCLS"),
      #   Commodities = c("WTI"              = "WTISPLC",
      #                   "Brent"            = "POILBREUSDM",
      #                   "Gold"             = "GOLDAMGBD228NLBM",
      #                   "Aluminium"        = "PALUMUSDM",
      #                   "Corn"             = "PMAIZMTUSDM",
      #                   "Soy"              = "PSOYBUSDQ")
      # ),
    }  # Use case_when to resolve names look. 
    
    index_cor <- behavior_data %>%
      pivot_wider(names_from = symbol, values_from = price) %>%
      select(-date) %>%
      na.omit() %>%
      cor()
    
    index_cor
    
  })
  
  # Rolling Correlation 
  rolling_cor <- eventReactive(input$observe, {

  behavior_data <- tq_get(input$variable, get = "economic.data",
                            from = input$daterange[1],
                            to = input$daterange[2]
    )
  
  price_return <- behavior_data %>%
    group_by(symbol) %>%
    tq_transmute(select = price,
                 mutate_fun = periodReturn,
                 period = "daily")
  
  baseline_return <- "DTWEXAFEGS" %>%
    tq_get(get  = "economic.data",
           from = input$daterange[1],
           to   = input$daterange[2]) %>%
    tq_transmute(select     = price,
                 mutate_fun = periodReturn,
                 period     = "daily")
  
  returns_joined <- left_join(price_return,
                              baseline_return,
                              by = "date") %>% na.omit
  
  rolling_cor <- returns_joined %>%
    tq_transmute_xy(x          = daily.returns.x,
                    y          = daily.returns.y,
                    mutate_fun = runCor,
                    n          = 6,
                    col_rename = "rolling.corr") %>% 
    na.omit()
  
  rolling_cor
  
  })
  
  # Price Returns 
  price_return <- eventReactive(input$observe, {
    
    behavior_data <- tq_get(input$variable, get = "economic.data",
                            from = input$daterange[1],
                            to = input$daterange[2]
    )
    

    price_return <- behavior_data %>%
           group_by(symbol) %>%
           tq_transmute(select = price,
                        mutate_fun = periodReturn,
                        period = "daily")
    
    
    price_return
    
  })
  
  # Price Evolution 
  price_evolution <- eventReactive(input$observe, {
    
    behavior_data <- tq_get(input$variable, get = "economic.data",
                            from = input$daterange[1],
                            to = input$daterange[2]
    )
    
    price_evolution <- behavior_data 
    
    
    price_evolution
    
  })
  

  

   # B) Outputs ####

  #description :::
  
  #corrmatrix
  output$index_cor   <- renderPlot({
    
    col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
    
    corrplot(index_cor(),
             method = "color",
             col = col(200),
             addCoef.col = "black",
             tl.col = "darkblue",
             order = "hclust")
   })
  
  #rollingcorr
  output$rolling_cor <- renderPlotly({
    
    # DXY_mean_cor <- mean(index_cor [,7:7])
    
     ggplotly( 
      rolling_cor() %>%
        filter(symbol != "DXY") %>% 
        ggplot(aes(x = date, y = rolling.corr, color = symbol)) +
        geom_hline(yintercept =  0, color = palette_light()[[8]]) +
        geom_point(size = 1.5)+
        geom_line(size  = 1) +
        labs(title = "DXY CUR Baseline ",br(),
             x = "", y = "Dynamic Correlation", color = "") +
        facet_wrap(~ symbol, ncol = 2) +
        # theme_tq() +
        theme_minimal()+
        scale_color_tq()+
        theme(legend.position = "none")
      
    )
    
    
  })
  
  #returns
  output$returns     <- renderPlotly({

    ggplotly(
      price_return()%>%
        mutate(Color = ifelse(daily.returns > 0.00, "green", "red")) %>%
        ggplot(aes(x = date, y = daily.returns, color = Color))+
        # theme_tq()+
        theme_minimal()+
        geom_point(size = 3)+
        geom_line(color = "gray", size = 1)+
        # geom_smooth(color = "orange", method = loess)+
        labs(x = "Date", y = "Price Returns",
             title = paste0(input$variable))+
        theme(legend.position = "none")
      )

  })
  
  #evolution
  output$evolution   <- renderPlotly({
    
    ggplotly(
      price_evolution()%>%
        ggplot(aes(x = date, y = price))+
        # theme_tq()+
        theme_minimal()+
        geom_point(color = "steelblue", size = 2)+
        geom_line(color = "gray", size = 1)+
        geom_smooth(color = "orange", method = loess)+
        labs(x = "Date", y = "Price Evolution",
             title = paste0(input$variable))
    )
    
  })
  

  #prediction ::: 
  


  
  output$macroPrimes <- renderTable({
    
    
  })
  
  
  

  
  
  
  
  })