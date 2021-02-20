# Data preparation from Juve 
# Contenido extra para armar otro tipo de mapas. 
# Autor: Jorge Juvenal Campos Ferreira

# Opciones 
options(scipen = 999)

# Librerias para manejar archivos geograficos
library(sf)
library(tidyverse)
library(viridis)

# funciones propias
# completaCeros <- function(x, n) {
#   
# } 


# Leer base de datos municipales
mpios <- st_read("https://raw.githubusercontent.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/master/geojsons/Division%20Politica/mpios2.geojson", quiet = T) %>% 
  select(CVEGEO, NOM_ENT, NOM_MUN)

plot(mpios, max.plot = 1)
lobstr::obj_size(mpios) # 7 megas

# Descargar informacion de produccion agricola 2019
prod_agricola <- read_csv("http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2019.csv", 
                          locale = locale(encoding = "ISO-8859-1")) %>% 
  select(Anio, 
         Idestado, Nomestado, 
         Idmunicipio, Nommunicipio, Nomcultivo, 
         Valorproduccion)

# Procesamiento
datos <- prod_agricola %>% 
  mutate(Idestado = case_when(str_length(Idestado) == 1 ~ str_c("0", Idestado), 
                              str_length(Idestado) == 2 ~ str_c("", Idestado)), 
         Idmunicipio = case_when(str_length(Idmunicipio) == 1 ~ str_c("00", Idmunicipio), 
                                 str_length(Idmunicipio) == 2 ~ str_c("0", Idmunicipio), 
                                 str_length(Idmunicipio) == 3 ~ str_c("", Idmunicipio))) %>% 
  mutate(CVEGEO = str_c(Idestado, Idmunicipio))

# BASES COMPLETAS ----
mpios     # Es la base geográfica
datos     # Es la base de datos de producción agrícola

# FILTRAMOS PARA Aguacate (Y si usas otro cultivo???????)
aguacate <- datos %>% 
  filter(Nomcultivo == "Aguacate")

cortes <- aguacate$Valorproduccion %>% 
  cut(breaks = 10)

min(aguacate$Valorproduccion)
max(aguacate$Valorproduccion)
quantile(aguacate$Valorproduccion)

levels(cortes)

# Generamos la base de datos para hacer el mapa
mapa <- merge(mpios, aguacate, by = "CVEGEO") 

class(mapa) # Checar que este objeto es un objeto combinado "sf" y "data.frame". 

# Elaboramos el primer mapa: 
# 1. Primer mapa (sin información, solo polígonos)
mapa %>% 
  ggplot() + 
  geom_sf()

# 2. Segundo mapa (con la paleta de colores)
mapa %>% 
  ggplot(aes(fill = Valorproduccion)) + 
  geom_sf(color = "brown", lwd = 0) + 
  # scale_fill_gradientn(colours = c("blue", "green", "yellow", "red")) 
  scale_fill_gradientn(colours = rev(viridis::magma(n = 200)), 
                       label = scales::dollar_format(),
                       breaks = c(5e8, 1e9, 2e9, 3e9))

# 3. Modificando los elementos del tema
mapa %>% 
  ggplot(aes(fill = Valorproduccion)) + 
  geom_sf(data = mpios 
          # %>% filter(NOM_ENT == "Michoacán")
          , 
          fill = "gray95") + 
  geom_sf(color = "brown") + 
  scale_fill_gradientn(colours = c("yellow", "blue", "green", "red")) + 
  # scale_fill_viridis_b() + 
  theme_bw() +
  theme(axis.text = element_blank(), 
        legend.position = "bottom", 
        axis.ticks = element_blank(), 
        panel.grid.major = element_blank())

# 3. Tema pegado de fuera

# Tema de mi mapa de ggplot
theme_map <- function(...) {
  theme_minimal() +
    theme(
      text = element_text(family = "Arial", color = "#22211d"),
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      # panel.grid.minor = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.major = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA), 
      panel.background = element_rect(fill = "white", color = NA), 
      legend.background = element_rect(fill = "white", color = NA),
      panel.border = element_blank(),
      plot.title = element_text(hjust = 0.5, size = 24, color = "#419067"), 
      plot.subtitle = element_text(hjust = 0.5, size = 20),
      ...
    )
}

mapa %>% 
  ggplot(aes(fill = Valorproduccion)) + 
  geom_sf(data = mpios %>% filter(NOM_ENT == "Michoacán"), 
          fill = "gray95") + 
  geom_sf(color = "brown") + 
  scale_fill_gradientn(colours = c("blue", "green")) + 
  theme_bw() +
  labs(title = "Titulo del mapa", 
       subtitle = "Subtitulo del mapa", 
       caption = "Fuente: ", 
       fill = "Valor de Producción") + 
  theme_map() + 
  theme(axis.text = element_blank(), 
        legend.position = "bottom", 
        axis.ticks = element_blank(), 
        panel.grid.major = element_blank()) 
  
