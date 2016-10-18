#
# UFCG - Sistemas de Recuperção de Informação
# Ygor Rodolfo Gomes dos Santos
# 111210452
#
# runApp("~/projeto/shinyApp")

library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title.
  headerPanel("Laboratório Extra - Sistemas de Recuperação de Informação"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view. The helpText function is also used to 
  # include clarifying text. Most notably, the inclusion of a 
  # submitButton defers the rendering of output until the user 
  # explicitly clicks the button (rather than doing it immediately
  # when inputs change). This is useful if the computations required
  # to render output are inordinately time-consuming.
  sidebarPanel(
    selectInput("option", "Escolha uma opção:", 
                c("Busca por filmes semelhantes", 
                  "Classificação de filmes", 
                  "Sistema de Recomendações")),
    
    #textInput("search", "Digite sua busca: ", value = ""),
    
    conditionalPanel(
      condition = "input.option != 'Sistema de Recomendações'",
      textInput("search", "Digite sua busca: ", value = "")
    ),
    
    conditionalPanel(
      condition = "input.option != 'Classificação de filmes'",
      numericInput("N", "Número de Resultados:", 10)
    ),
    
    
    helpText("Obs1: A opção 'Sistema de Recomendações' não foi implementada"),
    helpText("Obs2: No campo de busca deve-se escrever o nome do arquivo de legenda"),
    
    conditionalPanel(
      condition = "input.option != 'Sistema de Recomendações'",
      actionButton("button","Busca")
    ),
    
    conditionalPanel(
      condition = "input.option == 'Sistema de Recomendações'",
      actionButton("button2", "Recomendar")
    )
    
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations. Note the use of the h4 function to provide
  # an additional header above each output section.
  mainPanel(
    
    conditionalPanel(
      condition = "input.option == 'Sistema de Recomendações'",
      uiOutput("recomendationChose")
    ),
    
    h4("Resultado"),
    
    conditionalPanel(
      condition = "input.option == 'Busca por filmes semelhantes'",
      tableOutput("searchResult")
    ),
    
    conditionalPanel(
      condition = "input.option == 'Classificação de filmes'",
      textOutput("classificationResult")
    ),
    
    conditionalPanel(
      condition = "input.option == 'Sistema de Recomendações'",
      uiOutput("recomendationResults")
    )
  )
))