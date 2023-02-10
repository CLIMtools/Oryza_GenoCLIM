library(shiny)
library(DT)
library(readr)

ui <- fluidPage(
  # Add Javascript
  tags$head(
    tags$link(rel="stylesheet", type="text/css",href="style.css"),
    tags$head(includeScript("google-analytics.js")),
    tags$script(type="text/javascript", src = "md5.js"),
    tags$script(type="text/javascript", src = "passwdInputBinding.js"),
    tags$script('!function(d,s,id){var js,fjs=d.getElementsByTagName(s)    [0],p=/^http:/.test(d.location)?\'http\':\'https\';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");')
    
  ),
  useShinyjs(),
  
  uiOutput("app"),
  headerPanel(
    list(tags$head(tags$style("body {background-color: white; }")),
         "                     Oryza GenoCLIM", HTML('<img src="Oryza_GenoCLIM_logo.png", height="100px",  
                           style="float:left"/>','<p style="color:blue">                    Find Your Gene’s Environmental Association </p>' ))
  ),
  
  theme = shinytheme("journal") , 
  
  sidebarLayout(
    sidebarPanel(
      pickerInput("Locus_ID", "Locus_ID:", 
                  choices = unique(c(data()$Locus_ID, data2()$Locus_ID)), 
                  options = list(`actions-box` = TRUE), 
                  multiple = TRUE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Tab 1", DT::dataTableOutput("table1")),
        tabPanel("Tab 2", DT::dataTableOutput("table2"))
      )
    )
  )
)

server <- function(input, output) {
  data <- reactive({
    read_csv("data/Japonica_merged_final.csv")
  })
  
  data2 <- reactive({
    read_csv("data/Indica_merged_final.csv")
  })
  
  output$table1 <- DT::renderDataTable({
    filtered_data <- 
      data() %>%
      filter(Locus_ID == input$Locus_ID)
    filtered_data
  })
  
  output$table2 <- DT::renderDataTable({
    filtered_data2 <- 
      data2() %>%
      filter(Locus_ID == input$Locus_ID)
    filtered_data2
  })
  
  return(list(data2 = data2))
}
