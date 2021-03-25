# Librerias
library(jsonlite)
library(httr)
library(png)
library(magick)

# Ejemplo: uso de la PokeAPI (visitar)
# https://pokeapi.co (el API)
# https://pokeapi.co/docs/v2 (documentación)

# Supongamos que queremos obtener información sobre Pikachu, el 
## pokemon mas famoso de la historia. 

pokemon_de_interes <- "pikachu" # Acá puedes poner el nombre que te interese

# Llamada a la API
call1 <- paste0("https://pokeapi.co/api/v2/",
                "pokemon/", pokemon_de_interes, "/")

# Realizamos la llamada (Obtenemos la respuesta)
llamada <- GET(call1)
llamada # Status 200: Todo ok. 
class(llamada) # Tipo Response

# De la llamada, obtenemos la respuesta en formato JSON
# Formato JSON: https://en.wikipedia.org/wiki/JSON
get_data <- content(llamada, "text")
get_data
class(get_data)

# Del JSON, convertimos este texto en un objeto lista
get_data_JSON <- fromJSON(get_data, flatten = TRUE)
class(get_data_JSON)

# Renombramos el objeto, por comodidad
a <- get_data_JSON
a
class(a)

# De la lista, ya sacamos datos de importancia: 

# TABLAS ----

# Habilidades
a$abilities # Hidden ability es Habilidad Oculta del pokemon... es cosa del videojuego, no de los datos
habilidades <- a$abilities

# Formas
a$forms

# Indices de los juegos
a$game_indices

# Items con los que viene cuando se captura salvaje
a$held_items$item.name # Nombres
a$held_items$version_details

# Experiencia Base 
a$base_experience

# IMAGENES ----
pm <- a$sprites$front_default # Frente del Macho
ph <- a$sprites$front_female  # Frente de la Hembra
# Si el pokemon es asexual, sexo neutro o su especie solo tiene un tipo de sexo, no se tienen estas dos versiones de imagen.

# Imprimimos imagen
image_read(pm) %>% print() # Imprime en el viewer una imagen de un pikachu macho
image_read(ph) %>% print() # Imprime en el viewer una imagen de un pikachu hembra (la diferencia está en la forma de la cola)

# Descargamos la imagen.
curl::curl_download(pm, "01_Datos/Pokemon/FotoPikachuHembra.png")


# Si queremos hacer otro tipo de llamadas, tendríamos que checar la documentación O cambiarle el nombre al parámetro del pokemon de interés. 


