

# 4 downloading time series forecast


boton_descarga <- function(outputId, label = "Download"){
  tags$a(id = outputId, class = "btn btn-success shiny-download-link", href = "", 
         target = "_blank", download = NA, icon("file-excel"), label)
}