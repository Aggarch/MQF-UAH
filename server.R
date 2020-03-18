## Server

shinyServer(function(input, output) {
  
  
  index_cor <- eventReactive(input$observe, {
    
    {
      #
      # input <- list(variable = c("SP500","GOLDAMGBD228NLBM"),
      #               daterange = today() - 10,
      #               daterange2 = today())
    }
    
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
    }
    
    
    index_cor <- behavior_data %>%
      pivot_wider(names_from = symbol, values_from = price) %>%
      select(-date) %>%
      na.omit() %>%
      cor()
    
    index_cor
    
  })
  
  
  output$index_cor_plot <- renderPlot({
    
    col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
    
    corrplot(index_cor(),
             method = "color",
             col = col(200),
             addCoef.col = "black",
             tl.col = "darkblue",
             order = "hclust")
    
  })
  
  output$table <- renderDataTable({
    
  })
  
  
  output$macroPrimes <- renderTable({
    
    
  })
  
  
  
})