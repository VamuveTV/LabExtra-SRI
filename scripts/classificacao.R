library(tm)
library(FastKNN)

path = "~/projeto/shinyApp/legendas/"

classificacao = function(movie){
  
  if(identical(movie,  "")){
    return("Digite o filme")
  }
    
  file.names <- dir(path)
  doc.list = c()
  
  movie.indice <- 0
  
  for(i in 1:length(file.names)){
    filename <- paste(path, file.names[i], sep="")
    if(identical(movie,file.names[i])){
      movie.indice <- movie.indice + i
    }
    doc <- readChar(filename,file.info(filename)$size)
    doc.list[i] <- doc
  }
  
  if(movie.indice == 0){
    return("Filme nao encontrado")
  }
  
  N.docs <- length(doc.list)
  names(doc.list) <- paste0("doc", c(1:N.docs))
  
  my.docs <- VectorSource(doc.list)
  my.docs$Names <- names(doc.list)
  
  my.corpus <- Corpus(my.docs)
  my.corpus <- tm_map(my.corpus, removePunctuation)
  my.corpus <- tm_map(my.corpus, stemDocument)
  my.corpus <- tm_map(my.corpus, removeNumbers)
  my.corpus <- tm_map(my.corpus, stripWhitespace)
  
  term.doc.matrix.stm <- DocumentTermMatrix(my.corpus)
  
  term.doc.matrix <- as.matrix(term.doc.matrix.stm)
  
  tfidf.matrix = weightTfIdf(term.doc.matrix.stm)
  colnames(tfidf.matrix) <- colnames(term.doc.matrix)
  
  list.test.index <- list(movie.indice)
  
  matrix.movie <- tfidf.matrix[movie.indice,]
  
  list.test <- list(matrix.movie)
  matrixTest <- do.call(rbind, list.test)
  
  matrixTrain <- tfidf.matrix
  matrixTrain <- matrixTrain[-movie.indice,]
  
  distance_matrix <-  Distance_for_KNN_test(matrixTest, matrixTrain)
  
  labels <- read.csv("Categorias_Filmes.csv", header=TRUE, sep=",") 
  
  labels <- labels[-movie.indice,]
  
  matrixTest <- as.matrix(matrixTest) 
  
  knn <- knn_test_function(matrixTrain, matrixTest, distance_matrix, labels[,2], k=20)
  
  return(knn)
  
}