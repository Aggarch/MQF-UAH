#Analisys of 2 Tech - Assets  ->> Renta Variable tecnologicas. 
    
    
    #QCOM Vs NVIDIA:::


# Intro -------------------------------------------------------------------


    # NVIDIA:
    
    # Multinacional especializada en el desarrollo de unidades de procesamiento
    # gráfico y tecnologías de circuitos integrados para estaciones de trabajo,
    # ordenadores personales y dispositivos móviles. 
    # uno de los principales proveedores de circuitos integrados (CI)
    
    # Qualcomm :
    
    # Chipsets para la tecnología móvil, creador de plataforma Brew:
    # que permite la creación de aplicaciones para dispositivos móviles.
    # suministradores de procesadores para smartphones Snapdragon. 
    # Es un desarrollador de semiconductores para redes y comunicaciones,


    install.packages("quantmod")
    library(quantmod)
    install.packages("moments")
    library(moments)
    
    #Download Companies Historical Data -->> Range ( 2007-01-03 -->> 2018-02-15)
    
  #Data Frames:::
    
        DataQCOM = read.csv(file.choose())
        DataNVDA = read.csv(file.choose())
        class(DataQCOM)
        class(DataNVDA)
        head(DataQCOM); head(DataNVDA)       # Initial 6 days. 
        tail(DataQCOM); tail(DataNVDA)       # Last 6 days. 
        summary(DataQCOM);summary(DataNVDA)
        DataNDAQ = read.csv(file.choose())
      
        
        #NASDAQ Composite:::  Time Frame ( 2007-01-03  -->> 2018-02-16 )
        
        # Las empresas del sector tecnologico; NVIDIA y Qualcomm pertenecen ambas a el indice bursatil 
        # NASDAQ Composite -->> (National Association of Securities Dealers Automated Quotation)
        # es la segunda bolsa de valores electrónica y automatizada más grande de los Estados Unidos
        # Tiene más volumen de intercambio por hora que cualquier otra bolsa de valores en el mundo.
        # Más de 7000 acciones de pequeña y mediana capitalización cotizan en la NASDAQ. 
        # Comprende empresas de alta tecnología en electrónica,informática, telecomunicaciones,biotech.
        
        plot(DataNDAQ$Adj.Close,type="l",col=4,ylim=c(0,100),xlab="Days",ylab="Price",las=1,main="NASDAQ Composite INDEX")
        
        
        #Assets Perform Comparison: 
        
        #Using Adj.Close, to include in the analisys, dividends and splits. 
        
    
        plot(DataQCOM$Adj.Close,type="l",col=2,ylim=c(0,300),xlab="Days",ylab="Price",las=1,main="Stock Quotes - QCOM Vs NVDA")
        par(new=T)
        plot(DataNVDA$Adj.Close,type="l",col=3,ylim=c(0,300),xlab="Days",ylab="Price",las=1)
        

        
        # Contraste del comportamiento historico de ambas acciones;
        # tomando como fecha inicial y final  2007-01-03  -->>  2018-02-16
        # Qualcomm proceso color rojo.
        # Nvidia   proceso color verde.
        # En este rango de tiempo ambas acciones oscilaban por debajo de los (50 USD) 
        # Resulta llamativo el intervalo de tiempo transcurrido entre aproximadamente 
        # el 2250 y 2500, durante este patron de comportamiento de nvidia mostro iniciaba
        # una tendencia alcista agresiva, mientras Qualcomm respetaba su rango.  
    
        # NASDAQ Composite INDEX Vs 2 Assets -->> (NVIDIA & Qualcomm)
        
        plot(DataQCOM$Adj.Close,type="l",col=2,ylim=c(0,300),xlab="Days",ylab="Price",las=1,main="Stocks-QCOM & NVDA Vs NASDAQ")
        par(new=T)
        plot(DataNVDA$Adj.Close,type="l",col=3,ylim=c(0,300),xlab="Days",ylab="Price",las=1)
        par(new=T)
        plot(DataNDAQ$Adj.Close,type="l",col=4,ylim=c(0,300),xlab="Days",ylab="Price",las=1)
        
        # Aprox el inicio del alza de NVIDIA respecto a Qualcomm y su indice : 
        # NVIDIA supero drasticamente a Qualcomm y al indice de tecnologicas NASDAQ al  que ambas 
        # compañias pertenecen, brindo uno de los tantos eventos que estuvo relacionado con un despegue
        # de la cotizacion tan agresivo, que a priori cotizaba por debajo de Qualcomm y NASDAQ Comp. 
        
        DataNVDA$Date[2200]
        
        # Noticia relacionada con el evento ::: 
        
        # Nvidia reports record revenue of $2.9B, up 34% YoY
        # EPA / RITCHIE B. TONGONvidia reports record revenue of $2.9B, up 34% YoY
        # Nvidia Corporation reported revenue of $2.9 billion for the fourth quarter
        # up 34% compared to the same period of previous year, according to a statement 
        # published by the company on Thursday. 
        # Meanwhile, the company's stock jumped 7.50% in after-hours trade.
        # 
        # Earnings per diluted share (EPS) stood at a record $1.78, up 80% from a year ago.
        # The EPS were up 34% compared to $1.33 in the third quarter. 
        # Full-year EPS were reported at $4.82, rising 88% compared to previous year.
        # On the other hand, the revenue for the entire year amounted to $9.7 billion
        # climbing 41% from previous year.
        # "We achieved another record quarter, capping an excellent year,"
        # Founder and Chief Executive Jensen Huang said, adding: "Industries around the world
        # are racing to incorporate AI. Virtually every internet and cloud service provider has
        # embraced our Volta GPUs. Hundreds of transportation companies are using our NVIDIA DRIVE platform."

        #(https://www.teletrader.com/nvidia-reports-record-revenue-of-2-9b-up-34-yoy/news/details/42114419?internal=1)

# Technical Analysis ------------------------------------------------------
    
    
        getSymbols("QCOM")
        candleChart(QCOM,multi.col=TRUE,theme="white")
    
        getSymbols("NVDA")
        candleChart(NVDA,multi.col=TRUE,theme='white')
        
        # Desde el momento inicial de la observacion (2007), a la actualidad, 
        # NVIDIA ha tenido un mayor volumen de negociacion;
        # para una mejor apreciacion del comportamiento e indicadores tecnicos:
        # observemos a partir del periodo de interes (cuando nace la divergencia entre activos 2015)
        
        #Zoom:
        
        barChart(QCOM, subset="last 3.3 years")
        addRSI(n=14,maType = "EMA")
        addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
        addBBands(20,2)
        addSMA(n = 20,on=1)
        addSMA(n = 250,on=1)
        addSMA(n = 1000,on=1) 
        
        barChart(NVDA, subset="last 3.3 years")
        addRSI(n=14,maType = "EMA")
        addMACD(fast = 12, slow = 26, signal = 9, type = "EMA")
        addBBands(20,2)
        addSMA(n = 20,on=1)
        addSMA(n = 250,on=1)
        addSMA(n = 1000,on=1) 
       
       # En los ultimpos 3 años NVIDIA al alza bien definida
       # El comportamiento de Qualcomm fue menos atractivo. 
       # El periodo de tiempo desde (2015-01-02)el adj.close de Qualcomm perdío (10USD+)
       # el RSI como el MACD Convergen en sus minimos y maximos.
       # La convergencia entre dos indicadores basados en medias moviles 
       # Puede ser util para identificar zonas de sobrecompra, sobreventa . 
       # Operar si se espera la regresion a la media. cuando el RSI converja con MACD,
       # Exista  optimismo fundamental y esten en los rangos Max y/o Min; RSI[(80,70)-(30,20)]
             
    
#  Returns ----------------------------------------------------------------
    
        ret_QCOM=0
        ret_NVDA=0
        
        for (i in 2:length(DataQCOM$Adj.Close)){
          ret_QCOM[i-1] = log(DataQCOM$Adj.Close[i]/DataQCOM$Adj.Close[i-1])
        }
        
        for (i in 2:length(DataNVDA$Adj.Close)){
          ret_NVDA[i-1] = log(DataNVDA$Adj.Close[i]/DataNVDA$Adj.Close[i-1])
        }
        
        plot(ret_NVDA,type="l",col=3,ylim=c(-0.2,0.2),xlab="Days",ylab="RET",las=1,main="Cont. Daily Returns - QCOM & NVDA")
        par(new=T)
        plot(ret_QCOM,type="l",col=2,ylim=c(-0.2,0.2),xlab="Days",ylab="RET",las=1)
        
        # Los beneficios en función de la inversión reflejados a diario en tiempo continuo 
        # [(ingresos - inversión) / inversión] * 100 = retorno de inversión.
        # Intuitivamente da la impresion de que el activo Qualcomm (rojo) se ve sometido
        # a mas variaciones en la parte inferior que en la superior.
        # En el caso NVIDIA se aprecian mas oscilaciones en la parte superior sobretodo a partir 
        # del dia numero 2000. 
         
        
        
# Volatility Analisys -----------------------------------------------------
        
        #Rolling Window:::
        
        ws=450;                 # The window size; 1 year = 250 days  
        roll_sd_qualcomm =0;    # as usual,we need seeds before the loop
        roll_sd_nvidia=0;       # Cambio anual de la volatilidad. 
                                # ws or Window Size represents the number of days.  
        
        for (i in 1:(length(ret_QCOM)-ws)) {
          
          roll_sd_qualcomm [i]= sd(ret_QCOM[i:(i+ws)])   # daily sd
          
        }
        
        for (i in 1:(length(ret_NVDA)-ws)) {
          
          roll_sd_nvidia [i]= sd(ret_NVDA[i:(i+ws)])   # daily sd
          
        }
        
        roll_sd_qualcomm=roll_sd_qualcomm*sqrt(250)           # now annual.
        roll_sd_nvidia = roll_sd_nvidia*sqrt(250)
        
        plot(roll_sd_qualcomm,type="l",col=2,las=1,ylim=c(0.1,0.6),ylab="Annual. STD",main="Rolling Windows of STD")
        par(new=T)
        plot(roll_sd_nvidia,type="l",col=3,las=1,ylim=c(0.1,0.6),ylab="Annual. STD")
       
         
        # Representation grafica de las volatilidades de Qualcomm(rojo) y NVIDIA(verde) ambos
        # exhiben cierta correlacion en la volatilidad a partir del dia 2000 las volatilidades
        # empiezan a diverger con mucha intensidad. 
        
        
# Econometric Model Linear Regression -------------------------------------
    
        
        plot(ret_NVDA,ret_QCOM,col=c(2,3),main="Returns; ret_NVDA Vs ret_QCOM")
        
        mymodel= lm(ret_NVDA~ret_QCOM)
        summary(mymodel)
       
        # Diagrama de dispersion. 
        # Modelo de regrresion lineal. 
        # El rendimiento de NVIDIA es 0.70 veces el rendimiento de QComm + Lambda. 
    
           
# Statisthics -------------------------------------------------------------
    
    mu_QCOM  = mean(ret_QCOM);mu_QCOM                #Tendencia central.
    sd_QCOM    = sd(ret_QCOM);sd_QCOM                #Standard Deviation. 
    sigma_QCOM = sd(ret_QCOM);sigma_QCOM             #Varianza -->> Dispersion de datos.
  
  skewness_QCOM = skewness(ret_QCOM);skewness_QCOM   #Coeff de asimetría.  
  kurtosis_QCOM = kurtosis(ret_QCOM);kurtosis_QCOM   #Cercanía a la media
  cor(ret_QCOM,ret_NVDA)                             #Indice de correlacion.  
        
    mu_NVDA  = mean(ret_NVDA);mu_NVDA
  sigma_NVDA = sd(ret_NVDA);sigma_NVDA
  sd_NVDA    = sd(ret_NVDA);sd_NVDA
  skewness_NVDA = skewness(ret_NVDA);skewness_NVDA
  kurtosis_NVDA = kurtosis(ret_NVDA);kurtosis_NVDA
  cor(ret_NVDA,ret_QCOM)
  
  # A Mayor Kurtosis mayor riesgo por Fat tails.
  
        hist(ret_QCOM,col=8,las=1)
        hist(ret_NVDA,col=6,las=1)
        
        #Density :: 
        
        plot(density(ret_QCOM),col=4,xlim=c(-0.15,0.15))
        plot(density(ret_NVDA),col=6,xlim=c(-0.15,0.15))
       
        #Datos estadisticos de los activos Qualcomm y NVIDIA.  
        
    
# ANNUALIAZED RISK & RETURN -----------------------------------------------
    
        mu_QCOM*250      
        sigma_QCOM*sqrt(250)
    
        mu_NVDA*250
        sigma_NVDA*sqrt(250)
        
        #Media anualizada y riesgo anualizado.
        #La rentabilidad media anualizada de Qualcomm (7%),se asocia a
        #Un nivel riesgo equivalente a la dispersion ó varianza de (30%).
        
        #En el caso de NVIDIA; La rentabilidad esperada será del (21,5%)
        #Correspondiente a una sigma de (47%)
        
        
 # Parametric VaRs
        
        VaRp_QCOM = sigma_QCOM*-1.65*100; VaRp_QCOM
        VaRp_NVDA = sigma_NVDA*-1.65*100; VaRp_NVDA
        
        # Perdida maxima esperada. 
        
 # Historical VaRs
        
        VaRh_QCOM =quantile(ret_QCOM,0.05)*100
        VaRh_NVDA =quantile(ret_NVDA,0.05)*100
        VaRh_QCOM
        VaRh_NVDA
      
        # El peor 5% -->> mas preciso que parametrico.
        
  # Simple Montecarlo
        
        r_simu_qualcomm=rnorm(10000000,mu_QCOM,sigma_QCOM) #Parecido a VaR en funcion de volumen(rnorm)
        r_simu_nvidia  =rnorm(10000000,mu_NVDA,sigma_NVDA)
        quantile(r_simu_qualcomm,0.05)
        quantile(r_simu_nvidia,0.05)
        hist(r_simu_nvidia,col=2)
        hist(r_simu_qualcomm,col=5)   
        
        # La diferencia entre la perdida maxima esperada entre NVIDIA y Qualcomm no es muy significativa 
        # Mas aun su la comparamos proporcionalmente con la diferencia mas dramatica que se observa en la rentabilidad media. 
        
        
        
 # Portfolio Theory --------------------------------------------------------
    
        #install.packages("fPortfolio")
        library(fPortfolio); library(tseries)
        
        qualcom = DataQCOM   #read.csv(file.choose())
        nvidia  = DataNVDA   #read.csv(file.choose())
        
        P = data.frame(qualcom$Adj.Close,nvidia$Adj.Close)
        matplot(P,type="l")
        
 # CONT COMP RETURNS
        
        ret=matrix(0,dim(P)[1],dim(P)[2])
        
        for (j in 1:dim(P)[2]){
          for (i in 2:dim(P)[1]){
            ret[i,j] = log(P[i,j]/P[i-1,j])
          }
        }
        
 # Graph
        matplot(ret,t="l", main= "daily returns")
        
        
 # EFFICIENT PORTFOLIOS [MARKOWITZ y CAPM]
        
        portfolio.optim(ret)
        pie(portfolio.optim(ret)$pw,main="weights opt port",c("Qualcomm","Nvidia"))
        get
        
        # Frontier Graph 
        
        frontierPlot(portfolioFrontier(data = as.timeSeries(ret)),risk = "VaR",las=1)
        tailoredFrontierPlot(portfolioFrontier(data = as.timeSeries(ret)),risk = "Sigma",las=1)
        
        #El Comportamiento de NVDA es mucho mas atractivo y en el pasado ha sido superior a de
        #Qualcomm pero en el presente no sabemos si dicho patron se seguira repitiendo
        #Podemos aprender acerca de los drivers que hicieron del 2015 un año tan bueno par NVIDIA
        #Y analizar si permanecen conmstantes o se repiten con frecuencia. 
        
        #https://www.fool.com/investing/general/2016/05/03/this-is-why-2015-was-so-great-for-nvidia-stock.aspx
        
        
        
        
        
 ################################### - Andrés García - MFC-UAH - ############################################

        