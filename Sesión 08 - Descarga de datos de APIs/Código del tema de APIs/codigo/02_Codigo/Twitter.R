library(tidyverse)
library(rtweet)

# Documentacion: 
# https://github.com/ropensci/rtweet

# Buscar tweets de un tema particular. 

# Busqueda Avanzada: https://twitter.com/search-advanced?lang=es
# Ejemplo: "Sismo" min_faves:100 lang:es until:2020-09-30 since:2020-09-28

query <- '"Sismo" min_faves:100 lang:es since:2021-03-18'


# Busqueda
# (Solo se pueden descargar 15,000 tweets cada 15 minutos)
bd <- search_tweets(query,  # Busqueda
              n = 10000, # Numero Maximo de Tweets
              include_rts = FALSE, # Incluir Rts
              retryonratelimit = TRUE)

# Nube de palabras: 
create_wordcloud <- function(data, stop_words = c(), num_words = 100, background = "white",  mask = NULL) {
  # Checar si esta instalado Pacman
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(wordcloud2, tm, stringr)
  
  # Pre-Función para eliminar simbolos raros
  quitar_signos <- function(x)  stringr::str_remove_all(x, pattern = rebus::char_class("¿¡"))
  
  # If text is provided, convert it to a dataframe of word frequencies
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
    # Removemos los signos de admiracion e interrogacion al reves
    corpus <- tm_map(corpus, quitar_signos)    
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
  
  freq_palabras <<- data
  
  # Make sure a proper num_words is provided
  # Nos aseguramos que un numero adecuado de palabras `num_provider` es generado`
  if (!is.numeric(num_words) || num_words < 3) {
    num_words <- 3
  }  
  
  # Grab the top n most common words
  # Recortamos la base de datos de palabras a un numero `n` especificado
  data <- head(data, n = num_words)
  if (nrow(data) == 0) {
    return(NULL)
  }
  wordcloud2(data, backgroundColor = background, color = "random-dark", fontFamily = "Asap", size = 2) 
}

# Creamos una visualización: 
create_wordcloud(data = bd$text)

# Si quieres guardar los datos 
openxlsx::write.xlsx(bd, "tweetsSismo.xlsx")

# Stream de Tweets; muestra estadística de Tweets en tiempo real. 
?stream_tweets
# # Stream de tweets (para CDMX)
stream_tweets_cdmx <- stream_tweets(c(-99.39, 
                                 19.04,
                                 -98.84,
                                 19.58), 
                               timeout = 30 # Segundos
                               )

stream_tweets_mex <- stream_tweets(c(-116.317590, 
                                 14.876505,
                                 -86.847877,
                                 32.759644), 
                               timeout = 30 # Segundos
)

# # Stream de tweets (para Todo Estados Unidos)
usa <- stream_tweets(
  c(-125, 26, -65, 49),
  timeout = 30
)

# OTROS DATOS ----

# Datos de usuario ----- 
cuenta = "JuvenalCamposF"
datos = rtweet::get_collections(cuenta)
id = datos$objects$users[[1]][1] %>% 
  unlist() %>% 
  as.character()
id

# Obtener la descripción de la bio
datos$objects$users[[id]]$description

# # Obtener a quienes sigue un usuario ----
following <- get_friends(cuenta)
following
# 
# ## Ver bien a los usuarios a los que sigues
following_data <- lookup_users(following$user_id)
following_data$screen_name
# 
# ## Quien sigue al usuario ----
# ## get user IDs of accounts following CNN
followers <- get_followers(cuenta, n = 75000)
# 
# ## checar bien los usuarios
followers_data <- lookup_users(followers$user_id)
followers_data$screen_name
# 
# # Likes y Favs
le_gusta_al_usuario <- get_favorites(cuenta, n = 100)


# Gráfica para practicar con la informacion 
favs_plot <- le_gusta_al_usuario %>%
  select(screen_name, text, created_at) %>%
  arrange(created_at) %>%
  mutate(Fecha = as.Date(created_at)) %>%
  group_by(Fecha) %>%
  count() %>%
  ggplot(aes(x = Fecha, y = n)) +
  geom_col() + 
  labs(title = str_c("@", cuenta), 
       subtitle = "Número de likes por día del usuario")

favs_plot

# Versión interactiva
plotly::ggplotly(favs_plot) # ¿Que día tuve más actividad?
