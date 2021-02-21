
# Librerias ----
# Si no tienes alguna, instálala
library(tidyverse)
library(sf)
library(viridis)
library(plotly)

# 1. Leer las bases de datos ----
# Geometrías 
# Acá lo tuve que cambiar a la ruta en internet. 
# Si quieres hacerle como en el video, descarga el archivo para tenerlo localmente
# Desde este enlace: https://github.com/JuveCampos/periodismoDeDatos2021/raw/main/Sesión%2004%20-%20Mapas%20en%20Ggplot/Ejercicio%20práctico%20Clase%2004%20-%20Mapas/01_Datos/mpios.geojson
# Y guardalo en tu carpeta 01_Datos
mpios <- st_read("https://raw.githubusercontent.com/JuveCampos/periodismoDeDatos2021/main/Sesión%2004%20-%20Mapas%20en%20Ggplot/Ejercicio%20práctico%20Clase%2004%20-%20Mapas/01_Datos/mpios.geojson") %>% 
  select(-c(COV_, COV_ID))

# Los objetos tipo "sf" son los que almacenan las geometrías
class(mpios)

# Verificamos las geometrias (tarda un poco)
plot(mpios, max.plot = 1)

# Leemos los Atributos 
idh <- read_csv("01_Datos/Indice de Desarrollo Humano.csv") %>% 
  filter(Year == 2015)

# Vemos los años de los datos (exploración)
unique(idh$Year)

# Variables para hacer el merge
# idh = CODGEO
# mpios = CVEGEO 

# FUNCIONES PARA JUNTAR TABLAS
# merge()
# right_join() (hay mas! Checa: https://rpubs.com/Juve_Campos/juntando_tablas)

# 1. Juntando tablas usando merge
map <- merge(x = mpios,
      y = idh, 
      by.x = "CVEGEO", 
      by.y = "CODGEO", 
      all.x = TRUE)

# o tambien:  2. Juntando tablas usando right_join()
mapa <- right_join(mpios, idh, 
                   c("CVEGEO" = "CODGEO"))
# Ambas tablas son lo mismo


# Creamos la lista de estados
estados <- unique(map$NOM_ENT)

# Vemos toda la lista de estados
estados

# Seleccionamos un estado (ponle tu estado para probar)
estado_seleccionado <- "Morelos"

# Nos quedamos con solo la geometría del estado 
map_estado <- map %>% 
  filter(NOM_ENT == estado_seleccionado)

# Corroboramos
plot(map_estado, max.plot = 1)

# Visualizacion de datos ----

# Hacemos el mapa
mapx <- map_estado %>% 
  # Declaramos los elementos estéticos
  ggplot(aes(fill = Valor)) + 
  # Generamos el mapa (y ponemos los perimetros en blanco)
  geom_sf(color = "gray90") + 
  # Cambiamos los colores del relleno
  scale_fill_gradientn(colors = viridis(begin = 0,
                                        end = 1,
                                        n = 10)
                       # # Si quieres que los valores de la escala vayan de 0 a 1
                       # , limits = c(0,1) 
                       ) +
  
  # Otro ejemplo de paletas, por si viridis se te hace muy compleja :P 
  # Silencia la anterior y corre esta: 
  # scale_fill_gradientn(colors = c("red", "orange", "yellow", "green")) +
  
  labs(title = "Indice de desarrollo humano (IDH)", # Título
       subtitle = "Año 2015", # Subtitulo
       fill = "Valor del IDH", # Nombre de la escala
       caption = "Fuente: Informe de Desarrollo Humano Municipal 2010-2015.\nTransformando México Desde lo Local" # Pie de pagina
  ) + 
  # Subir y centrar el titulo de la barra 
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5)) + 
  # Modificar el tema de la gráfica
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

# Ver el mapa: 
mapx

# Convertir a mapa interactivo:
plotly::ggplotly(mapx)

# Guardar imagenes en ggplot (Ojo, esto funciona porque 
# tengo una carpeta 03_Lecturas en mi directorio). 

ggsave(str_c("03_Lectura/mapa_",estado_seleccionado,".png"), 
       width = 10, 
       height = 6)
# Si no especificas W y H, se va a guardar con la proporción de la 
# ventana de tu Viewer. 


# Hacemos los demás mapas en bucle
for (estado_seleccionado in estados){
    
      map_estado <- map %>% 
        filter(NOM_ENT == estado_seleccionado)
      
      plot(map_estado, max.plot = 1)
      
      # Visualizacion de datos ----
      
      mapx <- ggplot(map_estado, 
             aes(fill = Valor)) + 
        geom_sf(color = "gray90") + 
        scale_fill_gradientn(colors = viridis(begin = 0, 
                                              end = 1, 
                                              n = 10)) + 
        labs(title = "Indice de desarrollo humano (IDH)", 
             subtitle = "Año 2015", 
             fill = "Valor del IDH", 
             caption = "Fuente: Informe de Desarrollo Humano Municipal 2010-2015.\nTransformando México Desde lo Local"
             ) + 
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
      
      # Convertir a mapa interactivo
      plotly::ggplotly(mapx)
      
      # Guardar imagenes en ggplot 
      ggsave(str_c("03_Lectura/mapa_",estado_seleccionado,".png"), 
             width = 10, 
             height = 6)
      
      print(str_c("Ya imprimí el estado ", estado_seleccionado))
}

# Checa qué pasó? Se imprimieron los demás estados? 
