
#  Log returns based correlations ----------------------------------------


library(tidyquant)
library(corrplot)


# Data
sp  <- tq_get("SP500", "economic.data"); sp
vix <- tq_get("VIXCLS","economic.data"); vix
dow <- tq_get("DJIA",  "economic.data"); dow


# Matriz de Retornos Logaritmicos 
behavior_data <- sp %>% 
  bind_rows(vix) %>% 
  bind_rows(dow) %>% na.locf() %>% 
  group_by(symbol) %>% 
  tq_transmute(select = price,
               mutate_fun = periodReturn,
               period = "monthly",
               type   = "log") %>%
  ungroup() %>% 
  pivot_wider(names_from = symbol, values_from = monthly.returns)


# Dickey - Fuller test::: 

behavior_data$SP500 %>% na.omit -> sp_ret

sp_ret %>% tseries::adf.test()
# Rechazo de hipotesis nula, es decir no hay raiz unitaria, 
# ergo la serie es estacionaria, para todos los elementos de la
# matriz de retornos {behavior_data}

# Dibujo de matriz de correlaciones 
index_cor_d <- behavior_data %>%
  na.locf() %>% 
  select(-date) %>% 
  cor() %>% 
  corrplot(method = "color",
           addCoef.col = "black",
           tl.col = "darkblue"
  )

index_cor_d



#  price based correlations ----------------------------------------


# wrong case !!



behavior_data_price <- sp %>% 
  bind_rows(vix) %>% 
  bind_rows(dow) %>% na.locf() %>% 
  pivot_wider(names_from = symbol, values_from = price)


index_cor_d_p <- behavior_data_price %>%
  na.locf() %>% 
  select(-date) %>% 
  cor() %>% 
  corrplot(method = "color",
           addCoef.col = "black",
           tl.col = "darkblue"
  )

index_cor_d_p


#browseURL("https://www.rdocumentation.org/packages/aTSA/versions/3.1.2/topics/adf.test")


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

