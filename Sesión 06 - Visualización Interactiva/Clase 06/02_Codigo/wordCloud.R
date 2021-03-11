# WordCloud
library(tidyverse)
library(readxl)
library(wordcloud2)
library(tm)

bd <- read_xlsx("01_Datos/TweetsGobernadores.xlsx")

create_wordcloud <- function(data, 
                             num_words = 100, 
                             background = "white", 
                             stop_words, mask = NULL, 
                             tamanio = 0.5) {
  #, palabra = NULL 
  # Si se provee el texto, convertirlo a un dataframe de frecuencia de palabras 
  if (is.character(data)) {
    # Convertimos a Corpus
    corpus <- Corpus(VectorSource(data))
    # Convertimos el texto dentro del Corpus a Minusculas
    corpus <- tm_map(corpus, tolower)
    # Removemos la puntuacion (.,-!?)
    corpus <- tm_map(corpus, removePunctuation)
    # Removemos los numeros
    corpus <- tm_map(corpus, removeNumbers)
    # Removemos las stopwords (palabras muy muy comunes que se usan para dar coherencia
    # a las oraciones. Para saber cuales, escribir: stopwords("spanish))
    corpus <- tm_map(corpus, removeWords, c(stopwords("spanish"), stop_words))
    # Generamos una matriz para hacer el conteo
    tdm <- as.matrix(TermDocumentMatrix(corpus))
    # Obtenemos el numero de la frecuencia de cada palabra
    data <- sort(rowSums(tdm), decreasing = TRUE)
    # Generamos una tabla con la palabra en una columna y su frecuencia de uso en otra 
    data <- data.frame(word = names(data), freq = as.numeric(data))
  }
  
  # Nos aseguramos que un numero adecuado de palabras `num_provider` es generado`
  if (!is.numeric(num_words) || num_words < 3) {
    num_words <- 3
  }  
  
  # Recortamos la base de datos de palabras a un numero `n` especificado
  data <- head(data, n = num_words)
  if (nrow(data) == 0) {
    return(NULL)
  }
  
  wordcloud2(data, backgroundColor = background, figPath = mask,  color = "random-light", size = tamanio) 
}

# Creamos una wordCloud
create_wordcloud(bd$text, stop_words = c("hola"), num_words = 200)
