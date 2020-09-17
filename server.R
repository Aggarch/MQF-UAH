

#  ( A-Z ) Server ####

shinyServer(function(input, output) {
  
  

  # A) Reactive Expressions ####
  
  # Market sentiment ----
  
  
  observeEvent(input$observer, {
    # Show a modal when the button is pressed
    shinyalert("Comming Soon! ", 
               "This analysis it's waiting for twitter approval",
               type = "info",showConfirmButton = T,
               showCancelButton = FALSE,  timer = 10000, animation = TRUE,
               closeOnEsc = T,
               closeOnClickOutside = T)
  })
  
  #sentiment
  sentiment <- eventReactive(input$observer, {
    

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
      dplyr::rename(Accounts=screen_name,
             Tweets = text) %>%
    

    tweets
    
    
    
    })
  
  
  google_trends <- eventReactive(input$observer, {
    
    ggtrend <- function(arg){ 
      
      arg = input$hashtag
      
      google.trends = gtrends(c(arg), gprop = "web", time = "all")[[1]]
      google.trends = dcast(google.trends, date ~ keyword + geo, value.var = "hits")
      
      google.trends = google.trends %>% 
        as_tibble() %>% 
        dplyr::rename(value = paste0(arg,"_world"))
      
      return(google.trends)
      
    }
    
    arg = input$hashtag
    gTrend <- ggtrend(arg)
    
    gTrend
    
  })
  
  #news
  newsp <- eventReactive(input$observer, {
    
    
    get_token()
    
    users <- c("business", "markets", "businessinsider","FT", "YahooFinance",
               "wef", "WSJmarkets","economics","AndgTrader")
    
    vip_tweeters <- lookup_users(users) %>% 
      select(screen_name, text) %>% 
      dplyr::rename(ACCOUNT = screen_name,
             TWEET = text) %>% head(30) 
    
  })
  
  #frecuency chrts
  frequency_tw <- eventReactive(input$observer,{
    
    get_token()
    
    
    tt <- function(ttt){
      rst <- search_tweets(q = ttt, n = 350, include_rts = FALSE)
      return(rst)
    }
  
    tweets <- tt(input$hashtag)
    
    tweets
   })
    

  
  # description ----
  
  observeEvent(input$observe, {
    # Show a modal when the button is pressed
    shinyalert(" Notification! ", "Click on -Describe- every time you change variables",
               type = "success",showConfirmButton = T,
               showCancelButton = FALSE,  timer = 40000, animation = TRUE,
               closeOnEsc = T,
               closeOnClickOutside = T)
  })
  
  # Correlation Matrixes
  
  index_cor_d <- eventReactive(input$observe, {
    
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to   = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to   = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }

 
    index_cor_d <- behavior_data %>%
      rbind(tq_get("USEPUINDXD", get = "economic.data",
                   from = input$daterange[1],
                   to   = input$daterange[2])) %>% 
      na.locf() %>% 
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "daily",
                   type   = "log") %>% 
      pivot_wider(names_from = symbol, values_from = daily.returns) %>%
      select(-date) %>% 
      na.locf() %>% 
      cor()
    
    index_cor_d
    
    
  })


  index_cor_m <- eventReactive(input$observe, {
    
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to   = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to   = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    index_cor_m <- behavior_data %>%
      na.locf() %>% 
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "monthly",
                   type   = "log") %>% 
      pivot_wider(names_from = symbol, values_from = monthly.returns) %>%
      select(-date) %>% 
      na.locf() %>% 
      cor()
    
    index_cor_m
    
    
  })
  
  index_cor_y <- eventReactive(input$observe, {
    
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to   = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to   = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    index_cor_y <- behavior_data %>%
      na.locf() %>% 
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "yearly",
                   type   = "log") %>% 
      pivot_wider(names_from = symbol, values_from = yearly.returns) %>%
      select(-date) %>% 
      na.locf() %>% 
      cor()
    
    index_cor_y
    
    
  })

  
  
  
  # Rolling Correlation 
  rolling_cor_w <- eventReactive(input$observe, {

    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      ) %>% na.locf()
      
      
    }else{


      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>%
        dplyr::rename(price = adjusted) %>%
        select(price, symbol, date) %>% na.locf()

    }
    
  # behavior_data <- behavior_data_1 %>% rbind(behavior_data_2)

  price_return <- behavior_data %>%
    group_by(symbol) %>%
    tq_transmute(select = price,
                 mutate_fun = periodReturn,
                 period = "weekly")
  
  baseline_return <- "DTWEXAFEGS" %>%
    tq_get(get  = "economic.data",
           from = input$daterange[1],
           to   = input$daterange[2]) %>%
    tq_transmute(select     = price,
                 mutate_fun = periodReturn,
                 period     = "weekly")
  
  returns_joined <- left_join(price_return,
                              baseline_return,
                              by = "date") %>% na.locf
  
  rolling_cor_w <- returns_joined %>%
    tq_transmute_xy(x          = weekly.returns.x,
                    y          = weekly.returns.y,
                    mutate_fun = runCor,
                    n          = 7,
                    col_rename = "rolling.corr") %>% 
    na.locf()
  
  rolling_cor_w
  
  })
  
  rolling_cor_m <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      ) %>% na.locf()
      
      
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>%
        dplyr::rename(price = adjusted) %>%
        select(price, symbol, date) %>% na.locf()
      
    }
    
    # behavior_data <- behavior_data_1 %>% rbind(behavior_data_2)
    
    price_return <- behavior_data %>%
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "monthly")
    
    baseline_return <- "DTWEXAFEGS" %>%
      tq_get(get  = "economic.data",
             from = input$daterange[1],
             to   = input$daterange[2]) %>%
      tq_transmute(select     = price,
                   mutate_fun = periodReturn,
                   period     = "monthly")
    
    returns_joined <- left_join(price_return,
                                baseline_return,
                                by = "date") %>% na.locf
    
    rolling_cor_m <- returns_joined %>%
      tq_transmute_xy(x          = monthly.returns.x,
                      y          = monthly.returns.y,
                      mutate_fun = runCor,
                      n          = 7,
                      col_rename = "rolling.corr") %>% 
      na.locf()
    
    rolling_cor_m
    
  })
  

  
  
  
  ## Price Returns 
  
  # Daily
  price_return_d <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    

    price_return_d <- behavior_data %>%
           group_by(symbol) %>%
           tq_transmute(select = price,
                        mutate_fun = periodReturn,
                        period = "daily",
                        type = "log")
    
    
    price_return_d
    
  })
  
  
  # weekly
  price_return_w <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    price_return_w <- behavior_data %>%
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "weekly",
                   type = "log")
    
    price_return_w
    
  })
  
  # monthly
  price_return_m <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    price_return_m <- behavior_data %>%
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "monthly",
                   type = "log")
    
    price_return_m
    
  })
  
  # yearly
  price_return_y <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    price_return_y <- behavior_data %>%
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "yearly",
                   type = "log")
    
    price_return_y
    
  })
  
  
  # Price Evolution 
  price_evolution <- eventReactive(input$observe, {
    
    if(!input$variable %in%  market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    price_evolution <- behavior_data 
    
    
    price_evolution
    
  })
  
 
  
  # Rolling Volatility daily ----
  return_d_vol <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    return_d_vol <- behavior_data %>% na.locf() %>% 
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "daily",
                   type = "log")%>% na.locf() %>% 
      column_to_rownames("date") %>% 
      dplyr::rename(Asset = "daily.returns")
    
    return_d_vol
    
  })
  
  # Rolling Volatility daily ----
  return_m_vol <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    return_m_vol <- behavior_data %>% na.locf() %>% 
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "monthly",
                   type = "log")%>% na.locf() %>% 
      column_to_rownames("date") %>% 
      dplyr::rename(Asset = "monthly.returns")
    
    return_m_vol
    
  })
  
 

# VaR ---------------------------------------------------------------------

  
  
  # daily returns for VaR and TailVaR ----
  return_var <- eventReactive(input$observe, {
    
    if(!input$variable %in% market_list$ETFs){ 
      
      behavior_data <- tq_get(input$variable, get = "economic.data",
                              from = input$daterange[1],
                              to = input$daterange[2]
      )
    }else{
      
      
      behavior_data <- tq_get(input$variable, get = "stock.prices",
                              from = input$daterange[1],
                              to = input$daterange[2]) %>% 
        dplyr::rename(price = adjusted) %>% 
        select(price, symbol, date)
      
    }
    
    
    return_var <- behavior_data %>%na.locf() %>% 
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "daily",
                   type = "log")%>% na.locf() %>% 
      column_to_rownames("date") %>% 
      dplyr::rename(Asset = daily.returns) %>% 
      select(-symbol)
    
    return_var
    
})
  
  
  var_plot_99 <- eventReactive(input$observe, {
  
  
  
  var_99_hist  <- VaR(return_var(),  p=0.99, method="historical")
  var_99_gauss <- VaR(return_var(),  p=0.99, method="gaussian")
  var_99_mod   <- VaR(return_var(),  p=0.99, method="modified")
  cvar_99_hist <- CVaR(return_var(), p=0.99, method="historical")
  cvar_99_gauss<- CVaR(return_var(), p=0.99, method="gaussian")
  cvar_99_mod  <- CVaR(return_var(), p=0.99, method="modified")
  
  vars_99 <- data.frame(rbind(var_99_hist,
                              var_99_gauss, 
                              var_99_mod,
                              cvar_99_hist,
                              cvar_99_gauss,
                              cvar_99_mod
  ))
  
  
  vars_99$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
  
  var_plot_99 <- melt(vars_99) %>% mutate(TailVaR = str_detect(type, "CVaR"),
                                          TailVaR = ifelse(TailVaR == "TRUE",1,0)) %>% 
    dplyr::rename(VaR = value)
  
  var_plot_99
  
  })
  
  
  
  var_plot_95 <- eventReactive(input$observe, {
    
    
    
    var_95_hist  <- VaR(return_var(),  p=0.95, method="historical")
    var_95_gauss <- VaR(return_var(),  p=0.95, method="gaussian")
    var_95_mod   <- VaR(return_var(),  p=0.95, method="modified")
    cvar_95_hist <- CVaR(return_var(), p=0.95, method="historical")
    cvar_95_gauss<- CVaR(return_var(), p=0.95, method="gaussian")
    cvar_95_mod  <- CVaR(return_var(), p=0.95, method="modified")
    
    vars_95 <- data.frame(rbind(var_95_hist,
                                var_95_gauss, 
                                var_95_mod,
                                cvar_95_hist,
                                cvar_95_gauss,
                                cvar_95_mod
    ))
    
    
    vars_95$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
    
    var_plot_95 <- melt(vars_95) %>% mutate(TailVaR = str_detect(type, "CVaR"),
                                            TailVaR = ifelse(TailVaR == "TRUE",1,0)) %>% 
      dplyr::rename(VaR = value)
    
    var_plot_95
    
  })
  
  

  var_plot_90 <- eventReactive(input$observe, {
    
    
  
    var_90_hist  <- VaR(return_var(),  p=0.90, method="historical")
    var_90_gauss <- VaR(return_var(),  p=0.90, method="gaussian")
    var_90_mod   <- VaR(return_var(),  p=0.90, method="modified")
    cvar_90_hist <- CVaR(return_var(), p=0.90, method="historical")
    cvar_90_gauss<- CVaR(return_var(), p=0.90, method="gaussian")
    cvar_90_mod  <- CVaR(return_var(), p=0.90, method="modified")
    
    vars_90 <- data.frame(rbind(var_90_hist,
                                var_90_gauss, 
                                var_90_mod,
                                cvar_90_hist,
                                cvar_90_gauss,
                                cvar_90_mod
    ))
    
    
    vars_90$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
    
    var_plot_90 <- melt(vars_90) %>% mutate(TailVaR = str_detect(type, "CVaR"),
                                            TailVaR = ifelse(TailVaR == "TRUE",1,0)) %>% 
      dplyr::rename(VaR = value)
    
    var_plot_90
    
  })
  
  
  
  
  var_plot_85 <- eventReactive(input$observe, {
    
    
    
    var_85_hist  <- VaR(return_var(),  p=0.85, method="historical")
    var_85_gauss <- VaR(return_var(),  p=0.85, method="gaussian")
    var_85_mod   <- VaR(return_var(),  p=0.85, method="modified")
    cvar_85_hist <- CVaR(return_var(), p=0.85, method="historical")
    cvar_85_gauss<- CVaR(return_var(), p=0.85, method="gaussian")
    cvar_85_mod  <- CVaR(return_var(), p=0.85, method="modified")
    
    vars_85 <- data.frame(rbind(var_85_hist,
                                var_85_gauss, 
                                var_85_mod,
                                cvar_85_hist,
                                cvar_85_gauss,
                                cvar_85_mod
    ))
    
    
    vars_85$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
    
    var_plot_85 <- melt(vars_85) %>% mutate(TailVaR = str_detect(type, "CVaR"),
                                            TailVaR = ifelse(TailVaR == "TRUE",1,0)) %>% 
      dplyr::rename(VaR = value)
    
    var_plot_85
    
  })
  
  
  var_plot_80 <- eventReactive(input$observe, {
    
    
    
    var_80_hist  <- VaR(return_var(),  p=0.80, method="historical")
    var_80_gauss <- VaR(return_var(),  p=0.80, method="gaussian")
    var_80_mod   <- VaR(return_var(),  p=0.80, method="modified")
    cvar_80_hist <- CVaR(return_var(), p=0.80, method="historical")
    cvar_80_gauss<- CVaR(return_var(), p=0.80, method="gaussian")
    cvar_80_mod  <- CVaR(return_var(), p=0.80, method="modified")
    
    vars_80 <- data.frame(rbind(var_80_hist,
                                var_80_gauss, 
                                var_80_mod,
                                cvar_80_hist,
                                cvar_80_gauss,
                                cvar_80_mod
    ))
    
    
    vars_80$type<-c("Hist VaR", "Gauss VaR", "Mod VaR", "Hist CVaR", "Gauss CVaR", "Mod CVaR")
    
    var_plot_80 <- melt(vars_80) %>% mutate(TailVaR = str_detect(type, "CVaR"),
                                            TailVaR = ifelse(TailVaR == "TRUE",1,0)) %>% 
      dplyr::rename(VaR = value)
    
    var_plot_80
    
  })
   
#Sys.sleep(3)
  
  # prediction ----
  
  observeEvent(input$observe_1, {
    # Show a modal when the button is pressed
    shinyalert("Notification!", "Click on  -Forecast- every time you change variables",
               type = "success",showConfirmButton = T,
               showCancelButton = FALSE,  timer = 40000, animation = TRUE,
               closeOnEsc = T,
               closeOnClickOutside = T)
  })
  
  
  # Rolling Volatility daily GARCH ----
  return_d_vol_t <- eventReactive(input$observe_1,{ 
    
    behavior_data <- tq_get(input$variable_1, get = "economic.data",
                            from = input$daterange_1[1],
                            to = input$daterange_1[2]
    )


    return_d_vol_t <- behavior_data %>% na.locf() %>%
      group_by(symbol) %>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "daily",
                   type = "log")%>% na.locf() %>%
      ungroup() %>%
      select(-symbol) %>%
      column_to_rownames("date") %>%
      dplyr::rename(Asset = "daily.returns")
    
    return_d_vol_t
    
  })
  
  
  #time_series
  time_series <- eventReactive(input$observe_1,{
    
    b_data <- tq_get(input$variable_1, get = "economic.data",
                            from = input$daterange_1[1],
                            to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      dplyr::rename(ds=date, y=price) %>%
      na.locf()

    
   m <- prophet(b_data)
  
    future   <- make_future_dataframe(m,periods = 90) 
     # mutate(weekdays = weekdays(ds)) %>% 
     # filter(!weekdays %in% c("Saturday", "Sunday")) %>% 
     # select(-weekdays)

   
   forecast <-  predict(m, future)

   time_series <- forecast

   time_series
    
  })
  
  
  performance <- eventReactive(input$observe_1,{
    
    b_data <- tq_get(input$variable_1, get = "economic.data",
                     from = input$daterange_1[1],
                     to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      dplyr::rename(ds=date, y=price) %>%
      na.locf()
    
    m <- prophet(b_data)
    
    i <- b_data %>% nrow()*.8
    
    asset.cv <- cross_validation(m, initial = i, period = 30, horizon = 65, units = 'days')
    head(asset.cv)
    
    # Performance
    asset.p <- performance_metrics(asset.cv) 
    
    performance <- asset.p 
    
  })
  
  
  crossval <- eventReactive(input$observe_1,{
    
    b_data <- tq_get(input$variable_1, get = "economic.data",
                     from = input$daterange_1[1],
                     to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      dplyr::rename(ds=date, y=price) %>%
      na.locf()
    
    m <- prophet(b_data)
    
    crossval <- cross_validation(m, initial = 40, period = 30, horizon = 65, units = 'days')

    # Performance
  
    crossval
    
  })
  
  
  #time_series_return
  time_series_rt <- eventReactive(input$observe_1,{
    
      b_data_rt <-  tq_get(input$variable_1, get  = "economic.data",
                        from = input$daterange_1[1],
                        to   = input$daterange_2[2]) %>%
                          tq_transmute(select     = price,
                                       mutate_fun = periodReturn,
                                       period     = "daily") %>%
                          dplyr::rename(ds = date, y = daily.returns) %>%
                          na.locf()
      

    m_rt <- prophet(b_data_rt)
    future_rt   <- make_future_dataframe(m_rt,periods = 90) 
      # mutate(weekdays = weekdays(ds)) %>% 
      # filter(!weekdays %in% c("Saturday", "Sunday")) %>% 
      # select(-weekdays)
    
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
      dplyr::rename(ds=date, y=price) %>%
      na.locf()
    
    
    
    m_decom <- prophet(b_data_decom)
    future_decom   <- make_future_dataframe(m_decom,periods = 90) 
      # mutate(weekdays = weekdays(ds)) %>% 
      # filter(!weekdays %in% c("Saturday", "Sunday")) %>% 
      # select(-weekdays)
    
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
       dplyr::rename(ds=date, y=price) %>%
       na.locf()
     
     
     
     m_tbl <- prophet(b_data_tbl)
     future_tbl   <- make_future_dataframe(m_tbl,periods = 90) 
       # mutate(weekdays = weekdays(ds)) %>% 
       # filter(!weekdays %in% c("Saturday", "Sunday")) %>% 
       # select(-weekdays)
     
     forecast_tbl <-  predict(m_tbl, future_tbl)
   
     time_series_changep <- forecast_tbl
     
     time_series_changep
     
   })
  
  # prescription -----

   observeEvent(input$observe_2, {
     # Show a modal when the button is pressed
     shinyalert("Notification!", "Click on -Diagnose- every time you change variables",
                type = "success",showConfirmButton = T,
                showCancelButton = FALSE,  timer = 40000, animation = TRUE,
                closeOnEsc = T,
                closeOnClickOutside = T)
   })
   
   
   # EPU - Economic Policy Uncertainty ::::
   
  EPU_alt <- eventReactive(input$observe_2,{
     
     # EPU_index <- tq_get("USEPUINDXD", get = "economic.data", from = today()-2000)
     # triggers if delta increase 10 % or more OR index equals or its above 90 days mean

     EPU_alt <- EPU_index %>%  select(-symbol) %>%
       mutate(delta = (EPU_index$price)/lag(EPU_index$price)-1)%>%
       mutate(delta_trigger = ifelse(delta >= 0.10 |
                                       EPU_index$price >= mean(EPU_index$price +
                                                                 sd(EPU_index$price)*2.3),1L, 0L)) %>%
       slice(-1) %>%
       arrange(desc(date)) %>%
       dplyr::rename(index = price, Risk = delta_trigger) %>%
       mutate(Risk = ifelse(Risk == 1, "OFF", "ON"),
              delta = scales::percent(round(delta,2)),
              index = round(index)) 
     
     EPU_alt
     
  })
  
  EPU_abst <- eventReactive(input$observe_2,{
    
    # EPU_index <- tq_get("USEPUINDXD", get = "economic.data", from = today()-2000)
    
     # Summary of Risk ON|OFF, current year. 
     EPU_abst <-   EPU_alt() %>% filter(year(date) >= year(today())) %>% 
       group_by(Risk) %>% summarise(n = n(), .groups = "drop_last") %>% 
       dplyr::rename( Days = n) %>% 
       mutate("%" = scales::percent( Days/sum(Days))) %>% 
       mutate_if(is.character, as.factor)
     
     EPU_abst
     
  })
  
  interest_rate_all <- eventReactive(input$observe_2,{
    
      # Past Rates: 

      interest_rate_all <- fff %>%   select(date, FFF = adjusted) %>% 
        left_join(fftu, by = "date") %>% 
        dplyr::rename(target_up = price) %>% 
        select(-symbol) %>% left_join(fftl, by = "date") %>% 
        dplyr::rename(target_low = price) %>% select(-symbol) %>% 
        left_join(effr, by = "date") %>% 
        dplyr::rename(EFFR = price) %>% select(-symbol) %>% 
        mutate(market_expectation = 100-FFF,
               fed_action = market_expectation-EFFR) %>% 
        na.locf() %>% 
        select(-target_low, -target_up, -FFF)
      
      interest_rate_all
      
})
  
  interest_rate_all_tbl <- eventReactive(input$observe_2,{
    
    # Past Rates: 
    
    interest_rate_all_tbl <- fff %>%   select(date, FFF = adjusted) %>% 
      left_join(fftu, by = "date") %>% 
      dplyr::rename(target_up = price) %>% 
      select(-symbol) %>% left_join(fftl, by = "date") %>% 
      dplyr::rename(target_low = price) %>% select(-symbol) %>% 
      left_join(effr, by = "date") %>% 
      dplyr::rename(EFFR = price) %>% select(-symbol) %>% 
      mutate(market_expectation = 100-FFF,
             fed_action = market_expectation-EFFR) %>% 
      na.locf() %>% 
      unite("Target Range", target_low, target_up, sep = " - ") %>% 
      arrange(desc(date)) %>% 
      mutate(market_expectation = round(market_expectation, 3),
                                    fed_action = round(fed_action,3)) %>% 
      dplyr::rename("Market Expectations" = market_expectation,
             "FED action" = fed_action,
             "Date" = date)
      

    interest_rate_all_tbl
    
  })
  
      
  # Model ;;; Neural Networks ------------------------------------------------
  
  
  ########################################
  #              NNET ZONE               #
  ########################################
  
  
  asset <- eventReactive(input$observe_2,{
    
    
    # Data Asset  ---------------------------------------------------------
    
    
    #input = list(variable_2 = "SP500") # 4 debugging
    
    
    if(!input$variable_2 %in% market_list$ETFs){
      
      asset_selection <- tq_get(input$variable_2, get = "economic.data") %>%
        na.locf()
      
    }else{
      
      
      asset_selection <- tq_get(input$variable_2, get = "stock.prices") %>%
        dplyr::rename(price = adjusted) %>%
        select(price, symbol, date) %>%
        na.locf()
      
    }
    
    asset <- asset_selection %>%
      # dplyr::rename(asset = price) %>%
      select(-symbol) %>%
      mutate(sma = SMA(price, 2),
             ema = EMA(price, 3),
             dema = DEMA(price, 4),
             roc  = ROC(price),
             momentum = momentum(price),
             rsi = RSI(price, 5),
             strong_rsi = ifelse(rsi > 80, 1, 0),
             weak_rsi   = ifelse(rsi < 20, 1, 0)) %>%
      arrange(desc(date)) %>%
      mutate(up = ifelse(momentum > 0, 1 ,0)) %>%
      dplyr::rename(asset = price)
    
    asset
    
    
  }) # Check
  
  data <- eventReactive(input$observe_2,{
    # Data Model ~ {EPU, Asset, interest_rate} -----------------------------
    
    data <- asset() %>%
      left_join( EPU_alt(), by = "date") %>%
      fill(colnames(.) , .direction = "up") %>%
      
      mutate(Risk = ifelse(Risk == "ON", 1, 0),
             delta= index/lag(index)-1) %>%
      left_join(interest_rate_all(), by = "date") %>%
      fill(colnames(.) , .direction = "up") %>%
      
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
      select(-fed_h, -fed_action_strong) %>%
      mutate(up = as.factor(up))
    
    data
    
    
    
  })
  
  
  
  # Model Ml --------------------------------------------------------------
  
  # modelo <- eventReactive(input$observe_2,{
  #
  #     # Partition
  #     t.id <- createDataPartition(data()$up, p= 0.7, list = F)
  #
  #     set.seed(666)
  #    
  #      mod <- nnet(up ~ ., data() = data[t.id,],
  #                 size = 5 , maxit = 1000000, decay = .001, rang = 0.07,
  #                 na.action = na.locf, skip = T)
  #
  #     # Quality Model checks :::  
  #     # calcular valores probabilisticos y evaluar desempeño:
  #      
  #     # pred <- predict(mod, newdata = data[-t.id,], type = "class")
  #     # table(data[-t.id,]$up, pred,dnn = c("real", "preds"))
  #     #
  #     # pred2 <- predict(mod, newdata = data[-t.id,], type = "raw")
  #     # perf <- performance(prediction(pred2, data[-t.id,"up"]),
  #     #                     "tpr", "fpr")
  #     # plot(perf) # Perfect ROCR
  #     # pred <- predict(mod, newdata = data[-t.id,], type = "class")
  #    
  #     saveRDS(mod, "neural_networks/mod.rds")
  #      
  #
  # })
  
  
  
  
  # Applied Model of Nnet -------------------------------------------------------

  # generate future dataframe ::: 
  data_pred_show <- eventReactive(input$observe_2,{  
    
    
    data <- data()
    
    # Partition
    t.id <- createDataPartition(data$up, p= 0.7, list = F)
    
    set.seed(666)
    
    mod <- nnet(up ~ ., data = data[t.id,],
                size = 5 , maxit = 1000000, decay = .001, rang = 0.07,
                na.action = na.omit, skip = T)

    saveRDS(mod, "neural_networks/mod.rds")
    
    today() %m-% months(month(today())) -> t
    
      # Model future data
      asset_future <- tq_get(input$variable_2, get = "economic.data",from = t) %>%
        select(date, price) %>%
        dplyr::rename(ds = date, y = price)

      epu_future <- EPU_alt() %>%
        select(date, index) %>%
        dplyr::rename(ds = date, y = index)

      m <- prophet(asset_future)
      n <- prophet(epu_future)

      future <- make_future_dataframe(m, periods = 7) 
         # mutate(weekdays = weekdays(ds)) %>% 
         # filter(!weekdays == "Saturday") %>% 
         # select(-weekdays)
      
      tail(future)
      
      future_epu <- make_future_dataframe(n, periods = 7) 
         # mutate(weekdays = weekdays(ds)) %>% 
         # filter(!weekdays == "Saturday")%>% 
         # select(-weekdays)
      
      tail(future_epu)

      forecast <- predict(m, future)
      forecast_epu <- predict(n, future_epu)

      # Future asset
      asset_future_price <-   tail(forecast[c('ds', 'yhat')]) %>%
        dplyr::rename(date = ds, asset = yhat) %>%
        mutate(sma = SMA(asset, 1),
               ema = EMA(asset, 1),
               dema = DEMA(asset,1),
               roc  = ROC(asset),
               momentum = momentum(asset),
               rsi = RSI(asset, 1),
               strong_rsi = ifelse(rsi > 80, 1, 0),
               weak_rsi   = ifelse(rsi < 20, 1, 0)) %>%
        mutate(up = ifelse(momentum > 0, 1 ,0)) %>%
        fill(roc, momentum, rsi,
             strong_rsi, weak_rsi, up, .direction = "up") %>%
        arrange(desc(date)) %>% slice(-1)

      # Fed actions == last, Asumming Ceteris paribus
      fed <- interest_rate_all() %>% tail() %>% select(-date) %>% slice(1:5)

      # Future EPU
      EPU_future_price <-   tail(forecast_epu[c('ds', 'yhat')]) %>%
        dplyr::rename(price = yhat, date = ds) %>%
        mutate(delta = price/lag(price)-1)%>%
        mutate(delta_trigger = ifelse(delta >= 0.09 |
                                        price >= mean(price +
                                                        sd(price)*5),1L, 0L)) %>%
        fill(delta, .direction = "up") %>%
        fill(delta_trigger, .direction =  "up") %>%
        # slice(-1) %>%
        arrange(desc(date)) %>%
        dplyr::rename(index = price, Risk = delta_trigger) %>%
        mutate(Risk = ifelse(Risk == 1, "OFF", "ON")) %>%
        mutate( delta= (index/lag(index)-1)) %>%
        # left_join(interest_rate_all, by = "date") %>%
        mutate(delta_h = ifelse(delta > .50, 1, 0),
               delta_l = ifelse(delta < -.50, 1, 0),
               d_1_2_p = ifelse(between(delta, .1,.2), 1,0),
               d_1_2_n = ifelse(between(delta, -.2,-.1), 1,0),
               d_3_5_p = ifelse(between(delta, .3, .5),1, 0),
               d_3_5_n = ifelse(between(delta, -.5, -.3),1,0)) %>%
        slice(-1)
      
      
      # Future dataset
      data_new <- EPU_future_price %>%
        left_join(asset_future_price, by = "date") %>%
        cbind(fed) %>% as_tibble() %>%
        mutate(date = as.Date(date),
               Risk = ifelse(Risk == "ON", 1, 0))
      
      
      data_pred <-  data_new %>% rbind(head(data(), 30)) %>% na.locf()
      
      
      mod <- readRDS("neural_networks/mod.rds")
      
      data_pred_show <- data_pred%>%
        select(-delta_h, -delta_l, -d_1_2_n, -d_1_2_p,
               -d_3_5_p, -d_3_5_n, -strong_rsi, -weak_rsi) %>%
        mutate(pred = predict(mod, newdata = data_pred, type = "class"),
               prob = predict(mod, newdata = data_pred, type = "raw")[,1],
               prob = scales::percent(prob, accuracy = 40)) %>%
        mutate(prob = ifelse( date <= today(), "100%", prob ),
               pred = ifelse( pred == 1, "BUY", "SELL")) %>%
        select(-up, -pred, -prob) %>%
        dplyr::rename_all(.funs = toupper) %>% 
        select(-SMA, -EMA, -DEMA) %>% 
        dplyr::rename(EXPECTATION = MARKET_EXPECTATION)
        
    
    data_pred_show
    
  })

  # Neural network in regression ---------------------------------------------

  pred_show <- eventReactive(input$observe_2,{ 
    
    
    data_pred_show <- data_pred_show()
    
    
    t.id <- createDataPartition(data_pred_show$ASSET , p= 0.7, list = F)


    fit_n <- nnet(ASSET ~., data=data_pred_show[t.id, ],
                size = 15, decay = 0.2, rang = 0.1,
                maxit = 100000000, linout=T)

    saveRDS(fit_n, "neural_networks/fit.rds")

    fit_n <- readRDS("neural_networks//fit.rds")
     
    fit <-  readRDS("neural_networks/nnet_alternative_sp500.rds")
   
  pred_show <- data_pred_show %>%
    mutate(PRED_nnet = predict(fit, data_pred_show)[,1]) %>% 
    select(-FED_ACTION, -RISK, -RSI, -EXPECTATION, -EFFR,
           -DELTA, -ROC) %>% 
    head(100) %>%  
    mutate_if(is.numeric, round,2) %>% 
    mutate(W.Forecast  = PRED_nnet-(INDEX * .3))
    # rowwise() %>% 
    # mutate(diff =round(ASSET - mean(PRED_nnet,W.Forecast))) 
    # mutate(diff = ASSET - PRED_nnet)

  
  pred_show
  
  #archivos <- list.files() %>% enframe() %>% filter(str_detect(value, c("fit.rds|mod.rds"))) %>% pull(value)
  #walk(.x = archivos, .f = file.remove)
  
  })
  

  #})
      
      ##### GO to cookbook_gallery, neural_networks.R 4 regression 
      ##### Applied example to the data_pred_show example 
      ##### Create a plot of the neural network to share it 
      ##### Maybe nnet plot must be static.


   
#-----------------------------------------------------------------------------------------------------------------------------------#
   
  # B) Outputs ####
  
  # Market sentiment ---- 
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
      dplyr::rename(Accounts=screen_name,
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
      dplyr::rename(ACCOUNT = screen_name,
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
  
  
  #frequency
  output$google_trends <- renderPlotly({
    
    
    ggtrend <- function(arg){ 
      
      arg = input$hashtag
      
      google.trends = gtrends(c(arg), gprop = "web", time = "all")[[1]]
      google.trends = dcast(google.trends, date ~ keyword + geo, value.var = "hits")
      
      google.trends = google.trends %>% 
        as_tibble() %>% 
        dplyr::rename(value = paste0(arg,"_world"))
      
      return(google.trends)

    }
    
    
    arg = input$hashtag
    gTrend <- ggtrend(arg)
     
     gTrend
    
     gTrend <- 
      ggplotly(
      gTrend %>%  ggplot(aes(x=date, y = value))+
        geom_line(color = "gray")+
        geom_point( color = "steelblue")+
        geom_smooth(color = "pink")+
        theme_classic()+
        labs(x = "Date", y = " Ressecion Search" , 
          title = paste("Searches of" ,arg," at Google Trends"),
          subtitle = "information collected Since 2004"
       )
     ) 
  })

  
  # description ----
  
  output$treemap <- renderPlotly({ 
  
  
    conf_df <- coronavirus %>% 
    filter(type == "confirmed") %>%
    group_by(country) %>%
    summarise(total_cases = sum(cases), .groups = "drop") %>%
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
  })
  
  
  #rolling volatility 1m
  output$roll_vol_one <- renderPlotly({
    
  
  # plotly chart 
  chart.RollingPerformance(R = return_d_vol(), width = 22, FUN = "StdDev.annualized",
                           main = paste(input$variable, "Daily Log-Returns"), plot.engine = "plotly") 
    
    
  })
  
  
  #rolling volatility 3m
  output$roll_vol_three <- renderPlotly({
    
    
    # plotly chart 
    chart.RollingPerformance(R = return_d_vol(), width = 66, FUN = "StdDev.annualized",
                             main = paste(input$variable, "Daily Log-Returns"), plot.engine = "plotly") 
    
    
  })
  
  #rolling volatility 6m
  output$roll_vol_six <- renderPlotly({
    
    
    # plotly chart 
    chart.RollingPerformance(R = return_d_vol(), width = 132, FUN = "StdDev.annualized",
                             main = paste(input$variable, "Daily Log-Returns"), plot.engine = "plotly") 
    
    
  })
  
  

# vols m --------------------------------------------------------------------

  
  
  
  #rollingm volatility 1m
  output$rollm_vol_one <- renderPlotly({
    
    
    # plotly chart 
    chart.RollingPerformance(R = return_m_vol(), width = 2, FUN = "StdDev.annualized",
                             main = paste(input$variable, "Monthly Log-Returns"), plot.engine = "plotly") 
    
    
  })
  
  
  #rollingm volatility 3m
  output$rollm_vol_three <- renderPlotly({
    
    
    # plotly chart 
    chart.RollingPerformance(R = return_m_vol(), width = 3, FUN = "StdDev.annualized",
                             main = paste(input$variable, "Monthly Log-Returns"), plot.engine = "plotly") 
    
    
  })
  
  #rollingm volatility 6m
  output$rollm_vol_six <- renderPlotly({
    
    
    # plotly chart 
    chart.RollingPerformance(R = return_m_vol(), width = 6, FUN = "StdDev.annualized",
                             main = paste(input$variable, "Monthly Log-Returns"), plot.engine = "plotly") 
    
    
  })
  
  
  #vars_99
  output$vars_99 <- renderPlotly({
    
  
  ggplotly(
    ggplot(var_plot_99(),aes(x=type, y=VaR, fill=TailVaR)) + 
      geom_col()+
      theme_minimal()+
      labs(title = paste("Value at Risk for",input$variable)
        ))
  
    
  }) 
  
  
  
  #vars_95
  output$vars_95 <- renderPlotly({
    
    
    ggplotly(
      ggplot(var_plot_95(),aes(x=type, y=VaR, fill=TailVaR)) + 
        geom_col()+
        theme_minimal()+
        labs(title = paste("Value at Risk for",input$variable)
        ))
    
    
  }) 
    
  
  #vars_90
  output$vars_90 <- renderPlotly({
    
    
    ggplotly(
      ggplot(var_plot_90(),aes(x=type, y=VaR, fill=TailVaR)) + 
        geom_col()+
        theme_minimal()+
        labs(title = paste("Value at Risk for",input$variable)
        ))
    
    
  }) 
  
  
  
  #vars_85
  output$vars_85 <- renderPlotly({
    
    
    ggplotly(
      ggplot(var_plot_85(),aes(x=type, y=VaR, fill=TailVaR)) + 
        geom_col()+
        theme_minimal()+
        labs(title = paste("Value at Risk for",input$variable)
        ))
    
    
  }) 
  
  
  #vars_80
  output$vars_80 <- renderPlotly({
    
    
    ggplotly(
      ggplot(var_plot_80(),aes(x=type, y=VaR, fill=TailVaR)) + 
        geom_col()+
        theme_minimal()+
        labs(title = paste("Value at Risk for",input$variable)
        ))
    
    
  }) 
  
  
  
  output$density <- renderPlotly({
    
    
    coronavirus %>% 
      group_by(type, date) %>%
      summarise(total_cases = sum(cases), .groups = "drop") %>%
      pivot_wider(names_from = type, values_from = total_cases) %>%
      arrange(date) %>%
      mutate(active = confirmed - death - recovered) %>%
      mutate(active_total = cumsum(active),
             recovered_total = cumsum(recovered),
             death_total = cumsum(death)) %>%
      plot_ly(x = ~ date,
              y = ~ active_total,
              name = 'Active', 
              fillcolor = '#1f77b4',
              type = 'scatter',
              mode = 'none', 
              stackgroup = 'one') %>%
      add_trace(y = ~ death_total, 
                name = "Death",
                fillcolor = '#E41317') %>%
      add_trace(y = ~recovered_total, 
                name = 'Recovered', 
                fillcolor = 'forestgreen') %>%
      layout(title = "Distribution of Covid19 Cases Worldwide",
             legend = list(x = 0.1, y = 0.9),
             yaxis = list(title = "Number of Cases"),
             xaxis = list(title = "Source: Johns Hopkins University Center for Systems Science and Engineering"))
    
  })
  
  
  #corrmatrix DoD
  output$index_cor_d   <- renderPlot({
    
    col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
    
    corrplot(index_cor_d(),
             method = "color",
             col = col(200),
             addCoef.col = "black",
             tl.col = "darkblue",
             order = "hclust")
   })
  

  #corrmatrix MoM
  output$index_cor_m   <- renderPlot({
    
    col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
    
    corrplot(index_cor_m(),
             method = "color",
             col = col(200),
             addCoef.col = "black",
             tl.col = "darkblue",
             order = "hclust")
  })
  
  #corrmatrix YoY
  output$index_cor_y   <- renderPlot({
    
    col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
    
    corrplot(index_cor_y(),
             method = "color",
             col = col(200),
             addCoef.col = "black",
             tl.col = "darkblue",
             order = "hclust")
  })
  
  #rollingcorr
  output$rolling_cor_w <- renderPlotly({
    
    # DXY_mean_cor <- mean(index_cor [,7:7])
    
     ggplotly( 
      rolling_cor_w() %>%
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
  
  #rollingcorr
  output$rolling_cor_m <- renderPlotly({
    
    # DXY_mean_cor <- mean(index_cor [,7:7])
    
    ggplotly( 
      rolling_cor_m() %>%
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
  output$returns_d     <- renderPlotly({

    ggplotly(
      price_return_d()%>%
        mutate(Color = ifelse(daily.returns > 0.00, "green", "red")) %>%
        ggplot(aes(x = date, y = daily.returns, color = Color))+
        # theme_tq()+
        theme_minimal()+
        geom_point(size = 1)+
        geom_line(color = "gray", size = .3)+
        # geom_smooth(color = "orange", method = loess)+
        labs(x = "Date", y = "Log Price Returns",
             title = paste0(input$variable))+
        theme(legend.position = "none")
      )

  })
  
  
  
  output$returns_w     <- renderPlotly({
    
    ggplotly(
      price_return_w()%>%
        mutate(Color = ifelse(weekly.returns > 0.00, "green", "red")) %>%
        ggplot(aes(x = date, y = weekly.returns, color = Color))+
        # theme_tq()+
        theme_minimal()+
        geom_point(size = 1.5)+
        geom_line(color = "gray", size = .5)+
        # geom_smooth(color = "orange", method = loess)+
        labs(x = "Date", y = "Log Price Returns",
             title = paste0(input$variable))+
        theme(legend.position = "none")
    )
    
  })
  
  output$returns_m     <- renderPlotly({
    
    ggplotly(
      price_return_m()%>%
        mutate(Color = ifelse(monthly.returns > 0.00, "green", "red")) %>%
        ggplot(aes(x = date, y = monthly.returns, color = Color))+
        # theme_tq()+
        theme_minimal()+
        geom_point(size = 1.5)+
        geom_line(color = "gray", size = .5)+
        # geom_smooth(color = "orange", method = loess)+
        labs(x = "Date", y = "Log Price Returns",
             title = paste0(input$variable))+
        theme(legend.position = "none")
    )
    
  })
  
  
  output$returns_y     <- renderPlotly({
    
    ggplotly(
      price_return_y()%>%
        mutate(Color = ifelse(yearly.returns > 0.00, "green", "red")) %>%
        ggplot(aes(x = date, y = yearly.returns, color = Color))+
        # theme_tq()+
        theme_minimal()+
        geom_point(size = 1.5)+
        geom_line(color = "gray", size = .5)+
        # geom_smooth(color = "orange", method = loess)+
        labs(x = "Date", y = "Log Price Returns",
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
        geom_point(color = "steelblue", size = 1)+
        geom_line(color = "gray", size = .5)+
        geom_smooth(color = "orange", method = loess, size = .5)+
        labs(x = "Date", y = "Price Evolution",
             title = paste0(input$variable))
    )
    
  })
  
  output$summary    <- renderReactable  ({ 
    
    
    
    price_evolution <- price_evolution()%>%
      tq_transmute(select = price,
                   mutate_fun = periodReturn,
                   period = "monthly",
                   type = "log")
    
    table.Stats(price_evolution$monthly.returns) %>% 
            reactable::reactable(defaultPageSize =20, compact = T)    
    
    
    })
  
  
 
  # prediction ----
  
  
  output$garch_mod <- renderPlotly({
    
    garchspec <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                            variance.model = list(model = "sGARCH"),
                            distribution.model = "norm")
    # Estimate the model
    garchfit <- ugarchfit(data = return_d_vol_t(), spec = garchspec)
    
    # Use the method sigma to retrieve the estimated volatilities 
    garchvol <- sigma(garchfit)
    
    # Plot the volatility for 2017
    # garch_mod <- plot(garchvol)
    # garch_mod
    
    # ggplot garchvol model estimated 
    ggplotly( 
      garchvol %>% as.data.frame() %>%
        rownames_to_column(var = "Date") %>% 
        dplyr::rename(volatility = V1) %>% 
        as_tibble() %>% 
        mutate(Date = as.Date(Date)) %>% 
        ggplot(aes(x=Date, y=volatility))+
        theme_minimal()+
        geom_point(size = .7, color = "orange")+
        geom_line(size = .3, color = "gray")+
        geom_smooth(size = .2,se = FALSE)+
        labs(x = "Date", y = "GARCH(1,1)   Volatility",
             title = paste0(input$variable_1))
    )
    
  })
  
  
  
  output$vol_forecast <- renderPlotly({
    
    
  garchfit <- ugarchfit(data = return_d_vol_t(), spec = garchspec)
  
  garchforecast <- ugarchforecast(fitORspec = garchfit, 
                                  n.ahead = 66)
  
  garch_forecast <- sigma(garchforecast) %>% as.data.frame() %>% 
    rownames_to_column()
  
  colnames(garch_forecast) <- c("Periodo", "volatility")
  
  
  # ggplot garchvol forecated volatility
  ggplotly( 
    
  garch_forecast %>% as_tibble() %>% 
    separate(col = Periodo, into = c("T", "moment"), sep = "\\+") %>% select(-T) %>% 
    mutate(moment = as.numeric(moment)) %>% 
    ggplot(aes(x=moment, y = volatility)) +
    geom_point(size = 1, color = "orange")+
    geom_line(size = .5, color = "gray")+
    labs(x = "Date", y = "GARCH(1,1)   Volatility T+n",
         title = paste0(input$variable_1))+
    theme_classic()
  
  )
  
  
})
  
  
  #forecast
   output$fcast <- renderPlotly({

    b_data <- tq_get(input$variable_1, get = "economic.data",
                     from = input$daterange_1[1],
                     to = input$daterange_1[2]
    ) %>%
      select(date, price) %>%
      dplyr::rename(ds=date, y=price) %>%
      na.locf()
    #
     m <- prophet(b_data)

     
     ggplotly(
     plot(m,time_series())+
       xlab("Date") +
       ylab("Asset") +
       theme_get () + 
       ggtitle(paste0(input$variable_1))+
       add_changepoints_to_plot(m),dynamicTicks = TRUE,
     layerData = 1, originalData = F) %>%
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
                          dplyr::rename(ds = date, y = daily.returns) %>%
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
       dplyr::rename(ds=date, y=price) %>%
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
       dplyr::rename(ds=date, y=price) %>%
       na.locf()



     m_tbl <- prophet(b_data_tbl)
     future_tbl   <- make_future_dataframe(m_tbl,periods = 95) 
       # mutate(weekdays = weekdays(ds)) %>% 
       # filter(!weekdays %in% c("Saturday", "Sunday")) %>% 
       # select(-weekdays)
     
     forecast_tbl <-  predict(m_tbl, future_tbl)

     options(DT.options = list(dom = 'bfrtip',
                               ordering = F,
                               initComplete = JS("function(settings, json) {",
                                                 "$(this.api().table().header()).css({
                                              'font-size': '15px',
                                              'color': '#3b444b',
                                              'text-align':'center',
                                              'padding-left': '20px',
                                              'padding-right': '20px',
                                              'width': '100%'});",
                                                 "}")))

     
     changep <- 
       time_series_changep() %>% 
       select(ds, yhat, yhat_lower, yhat_upper) %>%
       mutate(yhat = round(yhat,2)) %>% 
       mutate(yhat_lower = round(yhat_lower,2)) %>% 
       mutate(yhat_upper = round(yhat_upper,2)) %>% 
       as_tibble() %>% 
       mutate(ds = as.Date(substr(ds,0,10))) %>% 
       left_join(b_data_tbl, by="ds") %>%
       filter(ds >= ymd(today()-7)) %>% 
       mutate(y=ifelse(is.na(y),"Uncertain",y)) %>% 
       dplyr::rename(Date = ds, Price = y) %>%
       select(Date, Price, everything()) %>% 
     
  
       datatable(rownames = F,style ='bootstrap4',
                 extensions = c('Buttons','Scroller'),
                 options = list(
                   dom = 'tip',
                   pageLength = 8,
                   info = FALSE,
                   scrollY = 350,
                   autoWidth = TRUE,
                   position = 'bottom'
                   # columnDefs = list(list(width = '200px', targets = c(2, 3)))
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
       dplyr::rename(ds=date, y=price) %>%
       na.locf()
     
     changep <- 
       time_series_changep() %>% 
       select(ds, yhat, yhat_lower, yhat_upper) %>%
       as_tibble() %>% 
       mutate(ds = as.Date(substr(ds,0,10))) %>% 
       left_join(b_data_tbl, by="ds") %>%
       filter(ds >= ymd(today()-7)) %>% 
       mutate(y=ifelse(is.na(y),"Uncertain",y)) %>% 
       dplyr::rename(Date = ds, Price = y ) %>% 
       select(Date, Price, everything())

     
   })
   
   output$down <- downloadHandler(
     filename = paste0(input$variable_1,"_forecast.xlsx"),
     content = function(file){ 
       openxlsx::write.xlsx(changep(), file)
       
     }
   )
   
   
   

   output$performance <- render_gt({ 
     
     
     performance() %>% head(8) %>%  gt()
     
     })
  
  
   output$crossv <- renderPlotly({ 
     
     performance <- crossval()
     
     ggplotly( plot_cross_validation_metric(performance, metric = 'mape') )    
     
     })
   
  # prescription ----
  
  # EPU Tables
   
  # Detailed
   output$epu_data <- renderReactable ({


     EPU_alt() %>% head(8) %>% 
       dplyr::rename(Delta = delta, "EPU Index" = index, 
              Date = date, "Risk Appetite" = Risk) %>%  reactable(compact = T,
                                                                  resizable = T)

   })

  # Grouped
   output$epu_abst <- renderPlotly ({


     ggplotly(EPU_abst() %>% ggplot(aes(x = Risk, y = Days, fill = Risk))+
                geom_col()+
                theme_classic()+
                labs(title = "Day count of Risk OFF/ON for the current year" )
     )
     

   })

  # Interest Rates graph
   output$rates_risk <- renderPlotly ({

  #EPU_alt <- EPU_alt()

   ggplotly (interest_rate_all() %>% ggplot(aes(date, EFFR))+
       geom_col(color = "#b1d6f0", fill = "blue")+
       geom_smooth(data = interest_rate_all(),
                   aes(x = date, y = market_expectation),
                   color = "#e03db7",
                   size = 1)+
       geom_smooth(data = EPU_alt(),
                   aes(x=date, index/250),
                   color = "#d60000")+
       theme_classic()+
       labs(title = "Effective Fed Funds Rate vs EPU",
            x_axis = "Date")
   )

  })

  # Fed Interest Rates Analisys
   output$fed_data <- renderReactable ({
     
      interest_rate_all_tbl() %>%
       dplyr::rename(Expectation = "Market Expectations",
                     "R-Range"= "Target Range") %>% 
       head(8) %>%
       reactable(compact = T,
                 resizable = T,
       )
     
   })
   
  
  # Neural Network visualizacion 
   output$ts_nnet_pred <- renderPlot({
     
    # fit <- readRDS("nnet_fit_sp500.rds") # trained
    
    fit <- readRDS("neural_networks/fit.rds") 
    
    source_url("https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r")
    
    plot(fit, max.sp = T)
    

   }) # checked
  

  # NNET posible futures 
   output$ts_nnet_pred_tbl <- renderReactable({
     
     pred_show() %>% reactable(compact = T, 
                               resizable = T)

     
   })
   
   
   
  # -------
   
    
  # Close of Main function  
  })


