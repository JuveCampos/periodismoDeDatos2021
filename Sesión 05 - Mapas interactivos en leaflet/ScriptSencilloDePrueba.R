# Checar si esta instalado Pacman
if (!require("pacman")) install.packages("pacman")

# Librerias
library(pacman)
p_load("sf", "leaflet", "tidyverse")

# Datos 
pto <- tibble(x = -99.263762, 
              y = 19.374481, 
              lugar = "CIDE") %>% 
  # Lo convertimos en objeto sf (geometrías)
  st_as_sf(coords = c("x", "y")) 

# Le asignamos el crs = 4326 (WGS84)
st_crs(pto) <- 4326

# Hacemos el mapa de leaflet
pto %>% 
  leaflet() %>% 
  addTiles() %>% 
  addMarkers(label = pto$lugar) 


