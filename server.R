#
# UFCG - Sistemas de Recuperção de Informação
# Ygor Rodolfo Gomes dos Santos
# 111210452
#

library(shiny)
library(rsconnect)
library(datasets)

source("scripts/buscar.R")
source("scripts/classificacao.R")
source("scripts/recomendacao.R")


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
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
  
  output$recomendationChose <- renderUI(
    checkboxGroupInput("escolha", "Marque os filmes que você gosta:",
                       choices = escolherFilmes())
  )
  
  output$recomendationResults <- renderTable({
    
      input$button2
      
      isolate(data.frame(
        Posição = c(1:input$N),
        Filmes = recomendar(input$escolha, input$N),
        stringsAsFactors=FALSE
      ))
    })
})
