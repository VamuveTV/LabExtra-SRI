#
# UFCG - Sistemas de Recuperção de Informação
# Ygor Rodolfo Gomes dos Santos
# 111210452
#

library(shiny)
library(datasets)

source("scripts/buscar.R")
source("scripts/classificacao.R")


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {

  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  # Show the first "n" observations
  output$searchResult <- renderTable({
    
    input$button
    
    isolate(data.frame(
      Posição = c(1:input$N),
      Filmes = search(input$search, input$N),
      stringsAsFactors=FALSE
    ))
  })
  
  # Show the first "n" observations
  output$classificationResult <- renderText({
    
    input$button
    
    isolate(classificacao(input$search))
  })
})
