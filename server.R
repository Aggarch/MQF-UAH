

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
  
  
  Sys.sleep(3)
  
  #prediction
  time_series <- eventReactive(input$observe_1,{
    
    b_data <- tq_get(input$variable_1, get = "economic.data",
                            from = input$daterange_1[1],
                            to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      rename(ds=date, y=price) %>%
      na.locf()



   m <- prophet(b_data)
   future   <- make_future_dataframe(m,periods = 60)
   forecast <-  predict(m, future)

   time_series <- forecast

   time_series
    
    
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
  
  #forecast
   output$fcast <- renderPlotly({

    b_data <- tq_get(input$variable_1, get = "economic.data",
                     from = input$daterange_1[1],
                     to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      rename(ds=date, y=price) %>%
      na.locf()
    #
     m <- prophet(b_data)

     ggplotly(
     plot(m,time_series()
          ),dynamicTicks = TRUE,
     layerData = 2, originalData = FALSE) %>%
       rangeslider() %>%
       layout(hovermode = "x")

     # %>%
     #   dynamicTicks = TRUE %>%
     #   rangeslider() %>%
     #   layout(hovermode = "x")



    # b_data <-  tq_get(input$variable_1, get  = "economic.data",
    #        from = input$daterange_1[1],
    #        to   = input$daterange_2[2] %>%
    #   tq_transmute(select     = price,
    #                mutate_fun = periodReturn,
    #                period     = "daily") %>%
    #   rename(ds = date, y = daily.returns) %>%
    #   na.locf()
    # )
    #
    # m <- prophet(b_data)
    #
    #  #ggplotly(
    #
    #   plot(m,time_series()
    #        )

  #   
   })



  
  output$macroPrimes <- renderTable({
    
    
  })
  
  
  

  
  
  
  
  })