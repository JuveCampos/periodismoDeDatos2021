# Librerias ----
library(rebus)
library(tidyverse)
library(readxl)

# Nombres ----
str1 <- "Juan y Ulises y Ramiro son los programadores backend de la unidad"
# 1. Genera, con Rebus, una expresión regular para extraer los nombres de los programadores. 
exp_1 <- "..."
str_view_all(str1, exp_1)

# Numeros ---
# Dada la siguiente tabla:
numeros <- tribble(~Ladas, 
                   "(595)",
                   "735",
                   "555-7771234",
                   "891", 
                   "lada: 443"
)
# 1. Genere una regex en rebus que capture la palabra "lada:"
pat <- "..."
str_view(numeros$Ladas, pattern = pat)

# 2. Genere una regex que catpure todos los numeros contenidos entre paréntesis.
pat <- "..."
str_view(numeros$Ladas, pattern = pat)

# 3. Genere una regex que capture los tres primeros digitos de cada string (si no inicia con digitos, no la captures).
pat <- "..."
str_view(numeros$Ladas, pattern = pat)

# 4. Genere una rebus que capture el guión y los todos los numeros que van a la derecha del guión. 
pat <- "..."
str_view(numeros$Ladas, pattern = pat)


# Titulos ----
nombres <- tribble(~Diputados, 
                   "Diputado Juan López",
                   "Diputado Pancho López",
                   "Diputada Liliana Juárez",
                   "Diputada Aracely Segura", 
                   "Diputade Ío Salvatore")

# Genere una regex en rebus que capture la palabra "Diputad"
pat <- "..."
str_view(nombres$Diputados, pattern = pat)

# Complemente el regex para que capture todas las palabras que inician con "Diputad" + una letra
pat <- "..."
str_view(nombres$Diputados, pattern = pat)

# Genere una regex que capture el apellido de todos los diputados. Coloquelo en una columna llamada "Apellidos" usando str_extract()
pat <- "..."
str_view(nombres$Diputados, pattern = pat)
str_extract(nombres$Diputados, pattern = pat)

# Genere una regex que capture el nombre de todos los diputados. Guarde los nombres en una columna llamada "Nombres", usando str_extract()
pat <- "..."
str_view(nombres$Diputados, pattern = pat)
str_extract(nombres$Diputados, pattern = pat)
# Mas sofisticado
str_extract(nombres$Diputados, pattern = pat) %>% 
  str_remove_all(pattern = SPC)

# Fechas ----

fechas <- tribble(~Fechas, 
                  "01-01-2001", 
                  "Primero de Enero del 2001", 
                  "01/01/2001", 
                  "01 01 2001",
                  "01@01@2001",
                  "01_01_2001",
                  "01-Ene-2001")

# 1. Genere un regex en rebus que detecte las palabras de y del, y los espacios que tienen a la derecha y a la izquierda...

pat <- "..."
str_view_all(fechas$Fechas,  
             pattern = pat)
fechas$Fechas <- str_replace_all(fechas$Fechas, 
                                 pattern = pat, 
                                 replacement = "-")

# 2. Genere un regex en rebus que detecte tanto guiones, cono diagonales, como espacios en Blanco y las arrobas. 
pat <- "..."
str_view_all(fechas$Fechas,  
             pattern = pat)
fechas$Fechas <- str_replace_all(fechas$Fechas, 
                                 pattern = pat, 
                                 replacement = "-")
fechas$Fechas

# 3. Iguale todas las fechas al formato %dd-%mm-%YYYY.
str_replace_all(fechas$Fechas, c("Primero" = "01", 
                                 "Ene" = "01",
                                 "Enero" = "01"))

# Estados ----
edos <- c("Mexico", 
          "Ciudad de Mexico", 
          "Coahuila De Zaragoza", 
          "Veracruz De Ignacio De La Llave")

# Genere una regex en rebus que Capture la primera Palabra (Para practicar)
pat <- "..."
str_view(edos, pattern = pat)
# str_extract(edos, pattern = pat)

# Genere una regex en rebus que Capture la palabra "De"
pat <- "..."
str_view(edos, pattern = pat)
str_replace(edos, pattern = pat, replacement = "de")

# Genere una regex en rebus que Capture la palabra "La"
pat <- "..."
str_replace(edos, pattern = pat)

# Genere una regex en rebus que Capture exactamente la palabra "Mexico"
pat_1 <- exactly("Mexico")
str_view(edos, pattern = pat_1)
str_replace_all(edos, pattern = pat_2, 
                replacement = "Estado de México")

# Reemplace los nombres de los estados por un nombre más adecuado....
diccionario_de_reemplazo <- c()
str_replace_all(edos, diccionario_de_reemplazo)


# Tweets ----
bd_tweets <- readxl::read_xlsx("tweets_santa_lucia.xlsx")

# Quien ha tuiteado mas 
bd_tweets %>% 
  group_by(screen_name) %>% 
  summarise(n = n()) %>% 
  arrange(-n) %>% 
  print(n = 30)

# Convierte el texto dentro de la columna "descripcion" a minusculas
bd_tweets$text <- str_`?`(bd_tweets$text)

# Genera un regex en rebus que capture la palabra "amlo" y "lopezobrador"
regex_presidente <- "..." 
tweets_presidente <- bd %>% 
  mutate(mencion.presidente = 
           str_detect(text, pattern =  regex_presidente)) %>% 
  filter(mencion.presidente == TRUE) %>% 
  select(screen_name, text)

# Genera un regex en rebus que capture los hashtags
regex_hashtag <- "..."
str_view_all(bd_tweets$text, 
             pattern = regex_hashtag, 
             match = TRUE)

# Genera un regex en rebus que detecte cuando un 
# usuario tenga en su nombre más de un número o más de un sìmbolo de guion bajo.
regex_bot <- "..."
str_view_all(bd_tweets$screen_name, 
             pattern = regex_bot, 
             match = TRUE)

# Genere una regex en rebus que detecte las siguientes dos 
# palabras después de "aeropuerto de santa lucía"

regex_aeropuerto <- "..."

str_view_all(bd_tweets$text, 
  pattern = regex_aeropuerto, 
  match = TRUE)
