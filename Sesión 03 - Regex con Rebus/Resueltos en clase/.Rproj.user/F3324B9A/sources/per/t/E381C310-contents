# Librerias ----
library(rebus)
library(tidyverse)
library(readxl)
library(htmltools)

# Nombres ----
str1 <- "Juan y Ulises y Ramiro y Juvenal son los programadores backend de la unidad"
# 1. Genera, con Rebus, una expresión regular para extraer los nombres de los programadores. 
exp_1 <- or1(c("Juan", "Ulises" , "Ramiro"))
exp_1 <- UPPER %R% one_or_more(WRD)
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
pat <- "lada:"
str_view(numeros$Ladas, pattern = pat)

# 2. Genere una regex que capture todos los numeros contenidos entre paréntesis.
pat <- "\\(" %R% one_or_more(DGT) %R% "\\)"
str_view(numeros$Ladas, pattern = pat)

# 3. Genere una regex que capture los tres primeros digitos de cada string (si no inicia con digitos, no la captures).
pat <- START %R% DGT %R% DGT %R% DGT
pat <- START %R% repeated(DGT, 3) # Alternativa
str_view(numeros$Ladas, pattern = pat)

# 4. Genere una rebus que capture el guión y los todos los numeros que van a la derecha del guión. 
pat <- "\\-" %R% one_or_more(DGT)
str_view(numeros$Ladas, pattern = pat)

# Titulos ----
nombres <- tribble(~Diputados, 
                   "Diputado Juan López",
                   "Diputado Pancho López",
                   "Diputada Liliana Juárez",
                   "Diputada Aracely Segura", 
                   "Diputade Ío Salvatore")

# Genere una regex en rebus que capture la palabra "Diputad"
pat <- "Diputad"
str_view(nombres$Diputados, pattern = pat)

# Complemente el regex para que capture todas las palabras que inician con "Diputad" + una letra
pat <- "Diputad" %R% WRD
str_view(nombres$Diputados, pattern = pat)

# Genere una regex que capture el apellido de todos los diputados. Coloquelo en una columna llamada "Apellidos" usando str_extract()
pat <- one_or_more(WRD) %R% END
str_view(nombres$Diputados, pattern = pat)
str_extract(nombres$Diputados, pattern = pat)
nombres$Apellidos <- str_extract(nombres$Diputados, pattern = pat)

# Genere una regex que capture el nombre de todos los diputados. Guarde los nombres en una columna llamada "Nombres", usando str_extract()
pat <- SPC %R% one_or_more(WRD) %R% SPC
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
pat <- SPC %R% or1(c("de", "del")) %R% SPC
str_view_all(fechas$Fechas,  
             pattern = pat)
fechas$Fechas <- str_replace_all(fechas$Fechas, 
                                 pattern = pat, 
                                 replacement = "-")

# 2. Genere un regex en rebus que detecte tanto guiones, cono diagonales, como espacios en Blanco y las arrobas. 
pat <- or1(c(char_class("-/@_"), SPC))
str_view_all(fechas$Fechas,  
             pattern = pat)
fechas$Fechas <- str_replace_all(fechas$Fechas, 
                                 pattern = pat, 
                                 replacement = "-")
fechas$Fechas

# 3. Iguale todas las fechas al formato %dd-%mm-%YYYY.
str_replace_all(fechas$Fechas, c("Primero" = "01", 
                                 "Enero" = "01",
                                 "Ene" = "01"))
# Recuerden que el orden importa! Cambia el orden de las ultimas dos para que veas que pasa!

# Estados ----
edos <- c("Mexico", 
          "Ciudad de Mexico", 
          "Coahuila De Zaragoza", 
          "Veracruz De Ignacio De La Llave")

# Genere una regex en rebus que Capture la primera Palabra (Para practicar)
pat <- START %R% one_or_more(WRD)
str_view(edos, pattern = pat)

# Genere una regex en rebus que Capture la palabra "De"
pat <- "De"

# ¿Cual es la diferencia entre estas dos? 
str_view(edos, pattern = pat)
str_view_all(edos, pattern = pat)

edos <- str_replace_all(edos, pattern = pat, replacement = "de")
edos

# Genere una regex en rebus que Capture la palabra "La"
pat <- "La"
edos <- str_replace(edos, pattern = pat, replacement = "la")
edos

# Genere una regex en rebus que Capture exactamente la palabra "Mexico"
pat_2 <- exactly("Mexico")
str_view(edos, pattern = pat_1)
edos <- str_replace_all(edos, pattern = pat_2, 
                replacement = "Estado de México")

# Reemplace los nombres de los estados por un nombre más adecuado....
diccionario_de_reemplazo <- c("Coahuila de Zaragoza" = "Coahuila", 
                              "Veracruz de Ignacio de la Llave" = "Veracruz", 
                              "Ciudad de Mexico" = "Ciudad de México")

edos <- str_replace_all(edos, diccionario_de_reemplazo)
edos


# Tweets ----
bd_tweets <- readxl::read_xlsx("tweets_santa_lucia.xlsx")

# Quien ha tuiteado mas?
bd_tweets %>% 
  group_by(screen_name) %>% 
  count() %>% 
  arrange(-n) %>% 
  print(n = 30)

# Convierte el texto dentro de la columna "text" a minusculas
bd_tweets$text <- str_to_lower(bd_tweets$text)

# Genera un regex en rebus que capture la palabra "amlo" y "lopezobrador"
regex_presidente <- or1(c("amlo", "lopezobrador"))
tweets_presidente <- bd_tweets %>% 
  mutate(mencion.presidente = 
           str_detect(text, pattern =  regex_presidente)) %>% 
  filter(mencion.presidente == TRUE) %>% 
  select(screen_name, text)

# Genera un regex en rebus que capture los hashtags
regex_hashtag <- "\\#" %R% one_or_more(WRD)
str_view_all(bd_tweets$text, 
             pattern = regex_hashtag, 
             match = TRUE)

# Genera un regex en rebus que detecte cuando un 
# usuario tenga en su nombre más de un número o más de un sìmbolo de guion bajo.
regex_bot <- or1(c(repeated("_", 4),repeated(DGT, 4)  ))

str_view_all(bd_tweets$screen_name, 
             pattern = regex_bot, 
             match = TRUE)

# Genere una regex en rebus que detecte las siguientes dos 
# palabras después de "aeropuerto de santa lucía"
regex_aeropuerto <- "aeropuerto de santa lucía" %R% 
  SPC %R% 
  repeated(capture(one_or_more(WRD) %R% 
                     optional(PUNCT) %R% 
                     SPC), 5)
# Este lo modifique de la clase :P 

# Checamos los tweets
str_view_all(bd_tweets$text, 
  pattern = regex_aeropuerto, 
  match = TRUE)

# Extraigo las 5 palabras (EXTRA, ESTO NO VIENE EN CLASE)
# AUN ASÍ, VE QUE RESULTA Y VE LOS PASOS REALIZADOS! :3
cinco_palabras <- bd_tweets %>% 
  transmute(cinco_palabras = str_extract(text, regex_aeropuerto)) %>% 
  filter(!is.na(cinco_palabras)) %>% 
  mutate(cinco_palabras = str_squish(cinco_palabras)) %>% 
  mutate(cinco_palabras = str_remove_all(cinco_palabras, pattern = PUNCT)) %>% 
  mutate(cinco_palabras = str_replace(string = cinco_palabras, 
                                      pattern = "aeropuerto de santa lucía", 
                                      replacement = "aeropuerto_de_santa_lucía")) %>% 
  tidyr::separate(col = cinco_palabras, 
                  into = c("Santa Lucía",
                           "Palabra_1", 
                           "Palabra_2", 
                           "Palabra_3", 
                           "Palabra_4", 
                           "Palabra_5"), 
                  sep = SPC)
