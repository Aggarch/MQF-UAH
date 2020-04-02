

#  ( A-Z ) Server ####

shinyServer(function(input, output) {
  
  

   # A) Reactive Expressions ####
  
  #Market sentiment ----
  
  #sentiment
  sentiment <- eventReactive(input$observe, {
    

    get_token()
    
    tt <- function(ttt){
      rst <- search_tweets(q = input$hashtag, n = 350, include_rts = FALSE)
      return(rst)
    }
    
    # read text in datatable
    
    
    tweets <- tt(input$hashtag) %>%
      group_by(screen_name) %>% 
      filter(created_at == max(created_at)) %>% 
      select(screen_name, text)%>% 
      rename(Accounts=screen_name,
             Tweets = text) %>%
    

    tweets
    
    
    
    })
  
  #news
  newsp <- eventReactive(input$observe, {
    
    
    get_token()
    
    users <- c("business", "markets", "businessinsider","FT", "YahooFinance",
               "wef", "WSJmarkets","economics","AndgTrader")
    
    vip_tweeters <- lookup_users(users) %>% 
      select(screen_name, text) %>% 
      rename(ACCOUNT = screen_name,
             TWEET = text) %>% head(30) 
    
  })
  
  #frecuency chrts
  frequency_tw <- eventReactive(input$observe,{
    
    get_token()
    
    
    tt <- function(ttt){
      rst <- search_tweets(q = ttt, n = 350, include_rts = FALSE)
      return(rst)
    }
  
    tweets <- tt(input$hashtag)
    
    tweets
   })
    

  
  #description ----
  
  # Correlation Matrix
  index_cor <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }

    index_cor <- behavior_data %>%
      pivot_wider(names_from = symbol, values_from = price) %>%
      select(-date) %>%
      na.omit() %>%
      cor()
    
    index_cor
    
  })
  
  # Rolling Correlation 
  rolling_cor <- eventReactive(input$observe, {

    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{


      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>%
        rename(price = adjusted) %>%
        select(price, symbol, date)

    }
    
    
   # behavior_data <- behavior_data_1 %>% rbind(behavior_data_2)
    
  
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
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    

    price_return <- behavior_data %>%
           group_by(symbol) %>%
           tq_transmute(select = price,
                        mutate_fun = periodReturn,
                        period = "daily")
    
    
    price_return
    
  })
  
  # Price Evolution 
  price_evolution <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    price_evolution <- behavior_data 
    
    
    price_evolution
    
  })
  
  
  Sys.sleep(3)
  
  #prediction ----
  
  #time_series
  time_series <- eventReactive(input$observe_1,{
    
    
    # if(!input$variable_1 %in% market_list$ETFs){ 
    #   
    #   b_data <- tq_get(input$variable_1, get = "economic.data",
    #                    from = input$daterange[1],
    #                    to = input$daterange[2]) %>% 
    #     select(date, price) %>%
    #     rename(ds=date, y=price) %>%
    #     na.locf()
    #   
    #   
    # }else{
    #   
    #   
    #   b_data <- tq_get(input$variable_1, get = "stock.prices",
    #                    from = input %>% selec$daterange[1],
    #                    to = input$daterange[2]) %>% 
    #     rename(price = adjusted) %>% 
    #     select(date, price) %>%
    #     rename(ds=date, y=price) %>%
    #     na.locf()
    #   
    # }
    

    b_data <- tq_get(input$variable_1, get = "economic.data",
                            from = input$daterange_1[1],
                            to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      rename(ds=date, y=price) %>%
      na.locf()

    
   m <- prophet(b_data)
   future   <- make_future_dataframe(m,periods = 90)
   forecast <-  predict(m, future)

   time_series <- forecast

   time_series
    
    
  })
  
  #time_series_return
  time_series_rt <- eventReactive(input$observe_1,{
    
      b_data_rt <-  tq_get(input$variable_1, get  = "economic.data",
                        from = input$daterange_1[1],
                        to   = input$daterange_2[2]) %>%
                          tq_transmute(select     = price,
                                       mutate_fun = periodReturn,
                                       period     = "daily") %>%
                          rename(ds = date, y = daily.returns) %>%
                          na.locf()
      

    m_rt <- prophet(b_data_rt)
    future_rt   <- make_future_dataframe(m_rt,periods = 90)
    forecast_rt <-  predict(m_rt, future_rt)

    time_series_rt <- forecast_rt

    time_series_rt

  })
  
  #ts_decomp
  time_series_decom <- eventReactive(input$observe_1,{
    
    b_data_decom <- tq_get(input$variable_1, get = "economic.data",
                     from = input$daterange_1[1],
                     to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      rename(ds=date, y=price) %>%
      na.locf()
    
    
    
    m_decom <- prophet(b_data_decom)
    future_decom   <- make_future_dataframe(m_decom,periods = 90)
    forecast_decom <-  predict(m_decom, future_decom)
    
    time_series_decom <- forecast_decom
    
    time_series_decom
    
    
  })
  
  #time_series_change_point
   time_series_changep <- eventReactive(input$observe_1,{
     
     b_data_tbl <- tq_get(input$variable_1, get = "economic.data",
                      from = input$daterange_1[1],
                      to = input$daterange_1[2]
     ) %>%
       select(date, price) %>%
       rename(ds=date, y=price) %>%
       na.locf()
     
     
     
     m_tbl <- prophet(b_data_tbl)
     future_tbl   <- make_future_dataframe(m_tbl,periods = 90)
     forecast_tbl <-  predict(m_tbl, future_tbl)
   
     time_series_changep <- forecast_tbl
     
     time_series_changep
     
   })
  
    
 # })
  

   
   
   
   
   # B) Outputs ####
  
  #Market sentiment ---- 
  #sentiment ::: 
  output$hashtag <- renderDataTable({
    
    get_token()
    
    
    tt <- function(ttt){
      rst <- search_tweets(q = ttt, n = 1000, include_rts = FALSE)
      return(rst)
    }
    
    options(DT.options = list(dom = 'bfrtip',
                              ordering = F,
                              initComplete = JS("function(settings, json) {",
                                                "$(this.api().table().header()).css({
                                              'font-size': '20px',
                                              'color': '#3b444b',
                                              'text-align':'center',
                                              'padding-left': '20px',
                                              'padding-right': '20px',
                                              'width': '150%'});",
                                                "}")))
    # read text in datatable
    
    tweets <- tt(input$hashtag) %>%
      group_by(screen_name) %>% 
      filter(created_at == max(created_at)) %>% 
      select(screen_name, text)%>% 
      rename(Accounts=screen_name,
             Tweets = text) %>%
      
      datatable( rownames = F, style = 'bootstrap4',
                 extensions = c('Buttons','Scroller'),
                 options = list(
                   dom = 'bfrtip',
                   pageLength = 30,
                   info = FALSE,
                   scrollY = 350,
                   autoWidth = TRUE
                 ))
    tweets
      })
  
  #newspapers
  output$news <- renderDataTable({
    
    get_token()
    
    
    ## lookup expert users opinion by screen_name or user_id
    users <- c("business", "markets", "businessinsider","FT", "YahooFinance",
               "wef", "WSJmarkets","economics","AndgTrader")
    
    vip_tweeters <- lookup_users(users) %>% 
      select(screen_name, text) %>% 
      rename(ACCOUNT = screen_name,
             TWEET = text) %>% head(30) 
    
    
    options(DT.options = list(dom = 'bfrtip',
                              ordering = F,
                              initComplete = JS("function(settings, json) {",
                                                "$(this.api().table().header()).css({
                                              'font-size': '20px',
                                              'color': '#3b444b',
                                              'text-align':'center',
                                              'padding-left': '20px',
                                              'padding-right': '20px',
                                              'width': '150%'});",
                                                "}")))
    # read text in datatable
    
    vip_tweets <- 
     vip_tweeters %>%
        datatable( rownames = F, style = 'bootstrap4',
                 extensions = c('Buttons','Scroller'),
                 options = list(
                   dom = 'bfrtip',
                   pageLength = 30,
                   info = FALSE,
                   scrollY = 350,
                   autoWidth = TRUE
                   
                 ))
    
    vip_tweets
    
  })
  
  #frequency
  output$freq <- renderPlotly({
    
    
    get_token()
    
    
    tt <- function(ttt){
      rst <- search_tweets(q = ttt, n = 100, include_rts = FALSE)
      return(rst)
    }
    
    tweets <- tt(input$hashtag)
    
    tweets
    
    ggplotly( 
      ts_plot(tweets, "1 hours") +
        ggplot2::theme_minimal() +
        ggplot2::geom_line(color='#1da1f2', size=1.5)+
        ggplot2::geom_point(color="#D16082", size=5)+
        ggplot2::geom_smooth(color="green")+
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
        ggplot2::labs(
          x = NULL, y = NULL,
          title = paste0("Frequency of " ,input$hashtag," Twitter statuses from past 12 hours"),
          subtitle = "Twitter status (tweet) counts aggregated using One-hour intervals",
          caption = "\nSource: Data collected from Twitter's REST API via rtweet"
        )
    )
  })

  #description ----
  
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
  

  #prediction ----
  
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
          )+ add_changepoints_to_plot(m),dynamicTicks = TRUE,
     layerData = 2, originalData = FALSE) %>%
       rangeslider() %>%
       layout(hovermode = "x")

  #   
   })
   
  #tsr forecast 
   output$tsr <- renderPlotly({

   b_data_rt <-  tq_get(input$variable_1, get  = "economic.data",
                        from = input$daterange_1[1],
                        to   = input$daterange_2[2] )%>%
                          tq_transmute(select     = price,
                                       mutate_fun = periodReturn,
                                       period     = "daily") %>%
                          rename(ds = date, y = daily.returns) %>%
                          na.locf()
    

   m_rt <- prophet(b_data_rt)
    
   # ggplotly( 
   # plot(m_rt, time_series_rt())
   # )
   ggplotly(
     plot(m_rt,time_series_rt()
     ),dynamicTicks = TRUE,
     layerData = 2, originalData = FALSE) %>%
     rangeslider() %>%
     layout(hovermode = "x")


   })
   
  #tsr decom 
   output$trend <- renderPlot({
     
     b_data_decom <- tq_get(input$variable_1, get = "economic.data",
                            from = input$daterange_1[1],
                            to = input$daterange_1[2]) %>%
       select(date, price) %>%
       rename(ds=date, y=price) %>%
       na.locf()
     
     
     
     m_decom <- prophet(b_data_decom)
     
     prophet_plot_components(m_decom,time_series_decom())
       
    })
  
  #ts_changepoint
   output$changep <- renderDataTable({
     
     b_data_tbl <- tq_get(input$variable_1, get = "economic.data",
                      from = input$daterange_1[1],
                      to = input$daterange_1[2]
     ) %>%
       select(date, price) %>%
       rename(ds=date, y=price) %>%
       na.locf()



     m_tbl <- prophet(b_data_tbl)
     future_tbl   <- make_future_dataframe(m_tbl,periods = 95)
     forecast_tbl <-  predict(m_tbl, future_tbl)

     options(DT.options = list(dom = 'bfrtip',
                               ordering = F,
                               initComplete = JS("function(settings, json) {",
                                                 "$(this.api().table().header()).css({
                                              'font-size': '20px',
                                              'color': '#3b444b',
                                              'text-align':'center',
                                              'padding-left': '20px',
                                              'padding-right': '20px',
                                              'width': '150%'});",
                                                 "}")))

     
     changep <- 
       time_series_changep() %>% 
       select(ds, yhat, yhat_lower, yhat_upper) %>%
       as_tibble() %>% 
       mutate(ds = as.Date(substr(ds,0,10))) %>% 
       left_join(b_data_tbl, by="ds") %>%
       filter(ds >= ymd(today()-7)) %>% 
       mutate(y=ifelse(is.na(y),"Uncertain",y)) %>% 
       rename(Date = ds, Price = y) %>%
       select(Date, Price, everything()) %>% 
     
  
       datatable(rownames = F,style ='bootstrap4',
                 extensions = c('Buttons','Scroller'),
                 options = list(
                   dom = 'bfrtip',
                   pageLength = 30,
                   info = FALSE,
                   scrollY = 350,
                   autoWidth = TRUE,
                   position = 'bottom',
                   columnDefs = list(list(width = '200px', targets = c(2, 3)))
                   )
       )

     
   })

  #downloable ::  
   changep <- reactive({
     
     b_data_tbl <- tq_get(input$variable_1, get = "economic.data",
                          from = input$daterange_1[1],
                          to = input$daterange_1[2]
     ) %>%
       select(date, price) %>%
       rename(ds=date, y=price) %>%
       na.locf()
     
     changep <- 
       time_series_changep() %>% 
       select(ds, yhat, yhat_lower, yhat_upper) %>%
       as_tibble() %>% 
       mutate(ds = as.Date(substr(ds,0,10))) %>% 
       left_join(b_data_tbl, by="ds") %>%
       filter(ds >= ymd(today()-7)) %>% 
       mutate(y=ifelse(is.na(y),"Uncertain",y)) %>% 
       rename(Date = ds, Price = y ) %>% 
       select(Date, Price, everything())

     
   })
   
   output$down <- downloadHandler(
     filename = paste0(input$variable_1,"_forecast.xlsx"),
     content = function(file){ 
       openxlsx::write.xlsx(changep(), file)
       
     }
   )

   
   output$macroPrimes <- renderTable({
    
    
  })
  
  
  
  
  })

save.image('environ.RData')