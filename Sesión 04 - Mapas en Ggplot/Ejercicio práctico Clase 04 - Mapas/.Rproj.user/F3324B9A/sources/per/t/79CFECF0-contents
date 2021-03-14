# Sesión 2. Elaboración de mapas en ggplot2() #
# Autor: Jorge Juvenal Campos Ferreira.       #
# Fecha: 27 de Agosto, 2020.                  #
# OJO! ESTO ES LO QUE VIMOS EN LA CLASE DEL SEMESTRE PASADO! 
# USTEDES VAYANSE AL SCRIPT clase_04.R
# De todos modos acá se los dejo. 

# Opciones ----
options(scipen = 999)

# Librerias a utilizar ----
library(pacman)
p_load(tidyverse, sf, viridis)

# Cargar Bases de Datos:

# ATRIBUTOS: ----
# Indice de Desarrollo Humano: 
idh <- read_csv("01_Datos/Indice de Desarrollo Humano.csv")
# Porcentaje de la población en Pobreza Extrema: 
pobreza <- read_csv("01_Datos/pobrezaExtrema.csv")

# DATOS GEOGRÁFICOS: ----
mpios <- st_read("01_Datos/mpios.geojson")
# Checamos que sea un objeto sf
class(mpios)
# Checamos que tenga lo que queremos
plot(mpios, max.plot = 1)


# PROBLEMA: 
# Soy un investigador, y me interesaría conocer el valor del IDH para 
# los municipios de Morelos para el ultimo año más reciente. 
max(idh$Year)
sort(unique(idh$Entidad))

# Generamos la base de datos 
idh_estado <- idh %>% 
  filter(Year == 2015) %>% 
  filter(Entidad == "Morelos")

# Mergeamos con la base geográfica
mapa <- merge(x = mpios,
      y = idh_estado,
      by.x = "CVEGEO", 
      by.y = "CODGEO", 
      all.y = TRUE) 

# Con las funciones join
mapa <- right_join(mpios, idh_estado, 
                  c("CVEGEO" = "CODGEO"))

# Checamos que sea un objeto sf
class(mapa)

# Checamos que sean la geometría que queremos
plot(mapa, max.plot = 1)

# Hacemos el mapa en ggplot()

# Versión 1 --- 
mapa %>% 
  ggplot(aes(fill = Valor)) + 
  geom_sf() 

# Versión 2 --- 
mapa %>% 
  ggplot(aes(fill = Valor)) +
  geom_sf() +
  scale_fill_gradientn(colors = viridis(begin = 0, 
                                        end = 1, 
                                        n = 10))

# Versión 3 --- 
map <- mapa %>% 
  ggplot(aes(fill = Valor)) + 
  geom_sf(color = "gray80") + 
  scale_fill_gradientn(colors = viridis(begin = 0, 
                                        end = 1, 
                                        n = 10),
                       limits = c(min(mapa$Valor),max(mapa$Valor))
                       ) + 
  labs(title = "Índice de Desarrollo Humano",
       subtitle = "Año: 2015", 
       fill = "IDH",
       caption = "Fuente: Informe de Desarrollo Humano Municipal 2010-2015.\nTransformando México Desde lo Local")  + 
  guides(fill = guide_colourbar(title.position="top", title.hjust = 0.5)) + 
  theme_bw() + 
  theme(legend.position = "bottom") + 
  theme(axis.text = element_blank(), 
        panel.grid = element_blank(), 
        panel.border = element_blank(), 
        panel.background = element_rect(),
        axis.ticks = element_blank()) + 
  theme(plot.title = element_text(hjust = 0.5, 
                                  colour = "gray10", 
                                  family = "Arial", 
                                  face = "bold", 
                                  size = 15), 
        plot.subtitle = element_text(hjust = 0.5, 
                                  colour = "gray50", 
                                  family = "Arial", 
                                  face = "bold", 
                                  size = 15), 
        plot.caption = element_text(colour = "gray50", 
                                    hjust = 1))

