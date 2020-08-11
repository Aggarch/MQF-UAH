
#  Log returns based correlations ----------------------------------------


library(tidyquant)
library(tidyverse)
library(corrplot)


# Data

sp  <- tq_get("SP500", "economic.data"); sp
vix <- tq_get("VIXCLS","economic.data"); vix
dow <- tq_get("DJIA",  "economic.data"); dow
epu <- tq_get("USEPUINDXD","economic.data")
gold <-tq_get("GOLDAMGBD228NLBM", "economic.data") 

# Log Returns Matrix

behavior_data <- sp %>%  
  bind_rows(vix) %>% 
  bind_rows(dow) %>% 
  bind_rows(epu) %>% 
  bind_rows(gold)%>% 
  na.locf() %>% 
  group_by(symbol) %>% 
  tq_transmute(select = price,
               mutate_fun = periodReturn,
               period = "monthly",
               type   = "log") %>%
  ungroup() %>% 
  pivot_wider(names_from = symbol,
              values_from = monthly.returns) %>% na.locf()


table.Stats(behavior_data$SP500)

# Dickey - Fuller test::: 

behavior_data$SP500 %>% na.omit -> sp_ret

sp_ret %>% tseries::adf.test()
# Rechazo de hipotesis nula, es decir no hay raiz unitaria, 
# ergo la serie es estacionaria, para todos los elementos de la
# matriz de retornos {behavior_data}

# Dibujo de matriz de correlaciones 
index_cor_d <- behavior_data %>%
 rename(VIX=VIXCLS,EPU=USEPUINDXD,GOLD=GOLDAMGBD228NLBM) %>% 
  na.locf() %>% 
  select(-date) %>% 
  cor(method = "pearson") %>% 
  corrplot(method = "pie",
           addCoef.col = "steelblue",
           tl.col = "black",
           type = "upper"
  )

index_cor_d



price_evolution <- sp%>%
  tq_transmute(select = price,
               mutate_fun = periodReturn,
               period = "daily",
               type = "log")


#  price based correlations ----------------------------------------


# wrong case !!



behavior_data_price <- sp %>% 
  bind_rows(vix) %>% 
  bind_rows(dow) %>%
  bind_rows(epu) %>% na.locf() %>% 
  pivot_wider(names_from = symbol, values_from = price)


index_cor_d_p <- behavior_data_price %>%
  na.locf() %>% 
  select(-date) %>% 
  cor() %>% 
  corrplot(method = "color",
           addCoef.col = "black",
           tl.col = "darkblue",
           type   = "upper"
  )

index_cor_d_p


browseURL("https://www.rdocumentation.org/packages/aTSA/versions/3.1.2/topics/adf.test")


# Stochastic Volatility  --------------------------------------------------


library(stochvol)

sim <- svsim(500, mu = 0, phi = 0.99, sigma = 0.2)

## Obtain 4000 draws from the sampler (that's too little!)
draws <- svsample(sim$y, draws = 4000, burnin = 100, priormu = c(-10, 1),
                  priorphi = c(20, 1.2), priorsigma = 0.2)

## Predict 20 days ahead
fore <- predict(draws, 20)

## plot the results
plot(draws, forecast = fore)

## Not run: 
## Simulate an SV process with leverage
sim <- svsim(500, mu = -10, phi = 0.95, sigma = 0.2, rho=-0.5)

## Obtain 8000 draws from the sampler (that's too little!)
draws <- svlsample(sim$y, draws = 4000, burnin = 3000, priormu = c(-10, 1),
                   priorphi = c(20, 1.2), priorsigma = 0.2,
                   priorrho = c(1, 1))

## Predict 20 days ahead
fore <- predict(draws, 20)

## plot the results
plot(draws, forecast = fore)




# ggplot of Standard & Poors 500

sp %>% filter(date >= "2019-08-01") %>% 
  ggplot(aes(x=date, y=price))+
  theme_minimal()+
  geom_point()+
  geom_line() +
  geom_smooth()+
  labs(x = "Date", y = "Price Evolution",
       title = "Standard & Poors 500")



behavior_data <- behavior_data %>% na.omit()

# S&P Log Returns

behavior_data %>% 
  select(date, SP500) %>% 
  filter(date >= "2019-08-01") %>% 
  ggplot(aes(x=date, y=SP500))+
  geom_point()+
  geom_line()+
  theme_minimal()+
  labs(x = "Date", y = "Log - Returns",
       title = "S&P Log Returns")
  

behavior_data %>% 
  filter( date >= "2019-08-01") %>%
  select(-date) %>%
  rename(Gold = GOLDAMGBD228NLBM,
         EPU  = USEPUINDXD,
         Dow  = DJIA,
         VIX  = VIXCLS,
         "S&P"  = SP500) %>% 
  cor() %>% 
     corrplot(
           method = "pie",  
           addCoef.col = "gray",
           tl.col = "blue")

# Correlation Matrix

behavior_data %>% 
  filter( date >= "2019-08-01") %>% 
  select(-date) %>% 
  cor() %>% 
  corrplot( method = "pie",  
            addCoef.col = "gray",
            tl.col = "blue")


# Rolling Correlation

price_return <- behavior_data_prices %>%
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
                            by = "date") %>% na.omit

rolling_cor <- returns_joined %>%
  tq_transmute_xy(x          = weekly.returns.x,
                  y          = weekly.returns.y,
                  mutate_fun = runCor,
                  n          = 7,
                  col_rename = "rolling.corr") 


