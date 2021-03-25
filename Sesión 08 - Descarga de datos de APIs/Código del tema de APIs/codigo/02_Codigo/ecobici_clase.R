# Librerias
library(tidyverse)
library(httr)
library(jsonlite)
library(sf)
library(leaflet)

# PROBLEMA: Queremos un mapa con la disponibilidad actual de bicis en cada estación de ecobici. 

# Manual de uso de API de ecobici: https://www.ecobici.cdmx.gob.mx/sites/default/files/pdf/manual_api_opendata_esp_final.pdf

# Solicitud de tus credenciales: https://www.ecobici.cdmx.gob.mx/es/informacion-del-servicio/open-data
# Te las dan super rápido :9

CLIENT_SECRET = "AcaPonesTuClaveSecreta"
CLIENT_ID = "AcaPonesElIdQueTeDan"
  
# Generas un token (valido por una hora, si tu analisis dura más, tendras que correr esto de nuevo)
pagina_token = str_glue("https://pubsbapi-latam.smartbike.com/oauth/v2/token?client_id={CLIENT_ID}&client_secret={CLIENT_SECRET}&grant_type=client_credentials
 ")  

# Guardas el Token Generado
ACCESS_TOKEN = fromJSON(pagina_token)$access_token

# Obtenemos lista de estaciones ----
respuesta_listado_estaciones = GET(str_glue("https://pubsbapi-latam.smartbike.com/api/v1/stations.json?access_token={ACCESS_TOKEN}"))
class(respuesta_listado_estaciones)

get_data <- content(respuesta_listado_estaciones, "text")
get_data
class(get_data)

# Del JSON, convertimos este texto en un objeto lista
get_data_JSON <- fromJSON(get_data, flatten = TRUE)
class(get_data_JSON)

# Renombramos el objeto, por comodidad
a <- get_data_JSON
a

# Convertimos los datos a un objeto sf, para hacer un mapa
estaciones = as_tibble(a$stations) %>% 
  st_as_sf(coords = c("location.lon", "location.lat" ), crs = 4326)

# Checamos la ubicación de los puntos
plot(estaciones, max.plot = 1)

# Obtenemos la disponibilidad ACTUAL de las estaciones ----
disponibilidad_estaciones = GET(url = str_glue("https://pubsbapi-latam.smartbike.com/api/v1/stations/status.json?access_token={ACCESS_TOKEN}"))

# Extraemos los datos
get_data <- content(disponibilidad_estaciones, "text")
get_data
class(get_data)

# Del JSON, convertimos este texto en un objeto lista
get_data_JSON <- fromJSON(get_data, flatten = TRUE)
class(get_data_JSON)

# Renombramos el objeto
a = get_data_JSON

# COnvertimos a tibble
disponibilidad = as_tibble(a$stationsStatus)

# Juntamos la disponibilidad con los puntos de arriba
disponibilidad_actual = left_join(estaciones, disponibilidad) %>% 
  select(id, 
         name, 
         contains("availability")) %>% 
  # Generamos una calificación de disponibilidad
  mutate(grado_disponibilidad = 
           case_when(availability.bikes <= 10 ~ 
                       "Poca disponibilidad",
                    between(availability.bikes, 11, 20) ~ 
                       "Existen bicicletas", 
                    availability.bikes > 20 ~ 
                      "Exceso de bicicletas"))

# Generamos una paleta de colores de semaforo
pal = colorFactor(palette = c("green", 
                              "yellow", 
                              "red"), 
                  domain = disponibilidad_actual$grado_disponibilidad)

# Hacemos el mapa ----
leaflet(disponibilidad_actual) %>% 
  addProviderTiles(providers$CartoDB.DarkMatter) %>% 
  addCircleMarkers(opacity = 1, 
                   fillOpacity = 1, 
                   color = pal(disponibilidad_actual$grado_disponibilidad), 
                   radius = 2, 
                   label = disponibilidad_actual$grado_disponibilidad)


