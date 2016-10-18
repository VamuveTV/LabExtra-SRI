library(tm)
library(FastKNN)
library(SnowballC)

# Caminho do diretório onde estão os arquivos de legendas
PATH = paste(getwd(),"legendas/",sep = "/")

escolherFilmes = function(){
  # Arquivos de legendas
  arquivos <- dir(PATH)
  
  # Número (N) de filmes que o usuário irá avaliar se é de seu interesse ou não
  N = 10
  
  # Lista que irá conter o(s) filme(s) interessante(s) para o usuário
  filmes.usuario = c()
  
  # Seleciona N filmes aleatórios que serão apresentados ao usuário
  filmes.oferta <- sample(1:length(arquivos), N, replace=F)
  
  for (i in 1:N) {
    filmes.usuario[i] <- arquivos[filmes.oferta[i]]
  }
  
  return(filmes.usuario)
}

recomendar = function(filmes, N){
  
  if(identical(filmes,  NULL)){
    return("")
  }
  
  print("Recomendando Filme")
  
  # Arquivos de legendas
  arquivos <- dir(PATH)
  
  # Lista que irá conter os documentos formatados exceto os que o usuário selecionou
  doc.lista = c()
  
  # Lista contendo os indices dos filmes selecionados pelo usuário
  filmes.usuario <- c()
  
  indice.usuario <- 0
  indice.geral <- 0
  for(i in 1:length(arquivos)){
    for (j in 1:length(filmes)) {
      filename <- paste(PATH, arquivos[i], sep="")
      if(identical(filmes[j],arquivos[i])){
        indice.usuario <- indice.usuario + 1
        filmes.usuario[indice.usuario] <- i
      }else{
        indice.geral <- indice.geral + 1
        nome <- paste(PATH, arquivos[i], sep="")
        doc <- readChar(nome,file.info(nome)$size)
        doc.lista[indice.geral] <- doc
      }
    }
  }
  
  print("o que tem aqui?")
  print(filmes.usuario)
  
  # Documento que conterá o conteúdo de todos os filmes que o usuário demostrou interesse
  doc.usuario <- "" 
  for(i in 1:length(filmes.usuario)){
    indice = filmes.usuario[i]
    nome <- paste(PATH, arquivos[indice], sep="")
    doc <- readChar(nome,file.info(nome)$size)
    doc.usuario <- paste(doc.usuario,doc) 
  }
  
  # Adiciona o documento com o conteúdo dos filmes selecionados pelo usuário na lista de documentos
  doc.lista[length(doc.lista)+1] <- doc.usuario
  
  numero.docs <- length(doc.lista)
  names(doc.lista) <- paste0("doc", c(1:numero.docs))
  
  # Cria o vetor dos documentos
  documentos <- VectorSource(doc.lista)
  documentos$Names <- names(doc.lista)
  
  corpus <- Corpus(documentos)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stemDocument)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  
  # Matriz documento-termo com todos os documentos
  term.doc.matrix.stm <- DocumentTermMatrix(corpus)
  term.doc.matrix <- as.matrix(term.doc.matrix.stm)  
  
  # Matriz tfidf com todos os documentos
  tfidf.matrix = weightTfIdf(term.doc.matrix.stm)
  colnames(tfidf.matrix) <- colnames(term.doc.matrix)
  
  # Gera a matriz de teste.
  matrixTeste = as.matrix(tfidf.matrix[numero.docs,])
  
  # Gera a matriz de treino
  matrixTreino <- tfidf.matrix[1:numero.docs-1,]
  
  # Gera a matriz de distancia para o KNN
  matrixDistancia <-  Distance_for_KNN_test(matrixTeste, matrixTreino)
  
  # Número de filmes a serem recomendados (TOP K filmes)
  TOP_K <- N
  
  # Mostrar filmes a serem recomendados baseando-se na similaridade
  similares <- k.nearest.neighbors(1,distance_matrix = matrixDistancia, k=TOP_K)
  
  filmes.recomendados = c()
  print("Filmes Recomendados: ")
  for(i in 1:length(similares)){
    filmes.recomendados[i] <- arquivos[similares[i]]
  }
}