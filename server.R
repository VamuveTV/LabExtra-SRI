#
# UFCG - Sistemas de Recuperção de Informação
# Ygor Rodolfo Gomes dos Santos
# 111210452
#

library(shiny)
library(datasets)

source("scripts/buscar.R")


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  # Generate a summary of the dataset
  searchResult <- reactive({
    if(identical(input$option,  "busca")){
      search(input$search, input$N)
    }
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    data.frame(
      Posição = c(1:input$N),
      Filmes = search(input$search, input$N),
      stringsAsFactors=FALSE
    )
  })
})
