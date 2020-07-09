
# for action triggering


boton_action <- function(inputId, label = "Action", icon_name){
  tags$a(id = inputId, class = "btn btn-primary", 
         actionButton(inputId, icon(icon_name), label)
  )
}