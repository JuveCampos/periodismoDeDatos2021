# Librerias ----
library(tidyverse)
library(sf)

# Datos ----
trends <- read_csv("01_Datos/google trends/geoMap-2.csv", 
                   skip = 2) %>% 
  rename(interes = `Ley Seca: (15/3/20 - 15/3/21)`) %>% 
  rename(ENTIDAD = Región)

pacman::p_load(sf, tidyverse) # Cargamos los paquetes
geometria_entidades <- read_sf("01_Datos/edos/entidades.geojson") %>% # Cargo los datos en un objeto
  st_transform(crs = 4326) %>% # Para homogeneizar o transformar el sistema de coordenadas de referencia
  select(-c(COV_, COV_ID, AREA, PERIMETER, CAPITAL)) # Seleccionando las columnas/variables que no quieres usar

plot(geometria_entidades, max.plot = 1)

# Funciones para checar como estan escritos los nombres ----
geometria_entidades$ENTIDAD
sort(trends$ENTIDAD)
cbind.data.frame(geometria_entidades$ENTIDAD, sort(trends$ENTIDAD))

trends <- trends %>% 
  mutate(ENTIDAD = str_replace_all(ENTIDAD, c("Michoacán" = "Michoacan de Ocampo", 
                                              "Estado de México" = "México", 
                                              "San Luis Potosí" = "San Luís Potosi", 
                                              "Veracruz" = "Veracruz de Ignacio de La Llave", 
                                              "Querétaro" = "Querétaro de Arteaga")))

# Vamos a hacer el merge con la llave "ENTIDAD"
# merge(geometria_entidades, trends, by = "ENTIDAD")
map = left_join(geometria_entidades, trends)

# Inspeccionamos
plot(map, max.plot = 1)

# Mapa en ggplot2
library(viridis)

# Hacemos el mapa ----
map %>% 
  ggplot(aes(fill = interes)) + 
  geom_sf(color = "gray") + 
  labs(title = "Mapa de Interés en la ley seca", 
       subtitle = "Búsquedas correspondientes al año pasado", 
       caption = "Fuente: Google Trends",
       fill = "Métrica de interés de google") + 
  theme_bw() + 
  scale_fill_gradientn(colors = magma(begin = 0, 
                                        end = 1, 
                                        n = 10)) + 
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5)) + 
  theme(plot.title = element_text(hjust = 0.5, 
                                  color = "gray10", 
                                  face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, 
                                     color = "gray50", 
                                     face = "bold"), 
        plot.caption = element_text(hjust = 1), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(),
        panel.background = element_blank(), 
        legend.position = "bottom"
  ) 

# Lo rehacemos, pero ahora lo guardamos en un objeto llamado plt

plt = map %>% 
  ggplot(aes(fill = interes)) + 
  geom_sf(color = "gray") + 
  labs(title = "Mapa de Interés en la ley seca", 
       subtitle = "Búsquedas correspondientes al año pasado", 
       caption = "Fuente: Google Trends",
       fill = "Métrica de interés de google") + 
  theme_bw() + 
  scale_fill_gradientn(colors = magma(begin = 0, 
                                      end = 1, 
                                      n = 10)) + 
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5)) + 
  theme(plot.title = element_text(hjust = 0.5, 
                                  color = "gray10", 
                                  face = "bold"), 
        plot.subtitle = element_text(hjust = 0.5, 
                                     color = "gray50", 
                                     face = "bold"), 
        plot.caption = element_text(hjust = 1), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(),
        panel.background = element_blank(), 
        legend.position = "bottom"
  ) 

# Lo convertimos a ggplotly
library(plotly)

# convertimos a plotly
ggplotly(plt)

mapa_interactivo = ggplotly(plt)
library(htmlwidgets)
saveWidget(mapa_interactivo, "mapaInteresLeySeca.html")

