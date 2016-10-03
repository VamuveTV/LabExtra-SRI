#
# UFCG - Sistemas de Recuperção de Informação
# Ygor Rodolfo Gomes dos Santos
# 111210452
#
# runApp("~/projeto/shinyApp")

library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
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
                list("Busca por filmes semelhantes" = "busca", 
                     "Classificação de filmes" = "classificacao", 
                     "Sistema de Recomendações" = "recomendacao")),
    
    textInput("search", "Digite sua busca: ", value = ""),
    
    numericInput("N", "Número de Resultados:", 10),
    
    helpText("Note: while the data view will show only the specified",
             "number of observations, the summary will still be based",
             "on the full dataset."),
    
    submitButton("Buscar")
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations. Note the use of the h4 function to provide
  # an additional header above each output section.
  mainPanel(
    h4("Resultado"),
    tableOutput("view")
  )
))