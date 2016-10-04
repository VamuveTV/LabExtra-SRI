library(tm)
library(FastKNN)

PATH = "~/projeto/shinyApp/legendas/"

search = function(movie, N){
  
  if(identical(movie,  "")){
    return("")
  }
  
  file.names <- dir(PATH)
  
  legendas <- c()
  
  count = 0
  for(i in 1:length(file.names)){
    filename <- paste(PATH, file.names[i], sep="")
    if(identical(movie,file.names[i])){
      count <- count + 1
    }
    doc <- readChar(filename,file.info(filename)$size)
    legendas <- c(legendas, doc)
  }
  
  if(count == 0){
    return("Filme nao existe")
  }
  
  docs_teste <- c()
  
  
  filmes_teste <- c(movie)
  docs_teste <- c()
  
  for(i in 1:length(filmes_teste)){
    filmes_teste <- paste(PATH, filmes_teste[i], sep="")
    doc_teste <- readChar(filmes_teste,file.info(filmes_teste)$size)
    docs_teste <- c(docs_teste, doc_teste)
  }
  
  my.treino <- VectorSource(c(legendas, docs_teste))
  
  my.treino.corpus <- Corpus(my.treino)
  my.treino.corpus <- tm_map(my.treino.corpus, removePunctuation)
  my.treino.corpus <- tm_map(my.treino.corpus, removeWords, stopwords("portuguese"))
  my.treino.corpus <- tm_map(my.treino.corpus, stemDocument)
  my.treino.corpus <- tm_map(my.treino.corpus, removeNumbers)
  my.treino.corpus <- tm_map(my.treino.corpus, stripWhitespace)
  
  matrix.treino.stm <- DocumentTermMatrix(my.treino.corpus)
  
  matrix.treino <- as.matrix(matrix.treino.stm)
  
  tfidf.matrix.treino = weightTfIdf(matrix.treino.stm)
  
  size <- length(legendas)
  
  treino <-  tfidf.matrix.treino[1:size, ]
  
  teste1 <- tfidf.matrix.treino[size+1,]
  
  matriz.distancia1 <-  Distance_for_KNN_test(teste1, treino)
  
  proximos1 <- k.nearest.neighbors(1,matriz.distancia1, k=N)
  
  filmes.proximos1 <- c()
  
  for (j in 1:N){
    filmes.proximos1[j] <- file.names[proximos1[j]]
  }
  
  return(filmes.proximos1)
}