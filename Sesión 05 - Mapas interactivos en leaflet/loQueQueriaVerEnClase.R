# Jorge Juvenal Campos Ferreira 
# Lección de mapas interactivos

# Librerias ----
library(sf) # Abrir bases de datos geograficas
library(leaflet) # Visualización interactiva (mapas)
library(tidyverse) # Manejo de bases de datos
library(htmlwidgets) # Para guardar paginas HTML
library(webshot) # Para imprimir paginas HTML

# Bases de datos ---- 
# Delitos a pasajeros de transporte público.
delitos <- st_read("https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/19.%20Urban/roboAPasajerosCDMX.geojson", quiet = T)
# Rutas de transporte público
rutas <- st_read("https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/19.%20Urban/rutas-y-corredores-del-transporte-publico-concesionado.geojson", quiet = T) %>% 
  st_zm() # Corrección para coordenadas en el eje Z

# Municipios/Alcaldías de la CDMX
mpios <- st_read("https://raw.githubusercontent.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/master/geojsons/Division%20Politica/mpios2.geojson", quiet = TRUE) %>% 
  filter(CVE_ENT == "09")

# Perimetro de la CDMX
edo <- st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/Sin_islas.geojson", quiet = TRUE) %>% 
  filter(ENTIDAD == "CIUDAD DE MÉXICO")

# Uno que no tiene crs 
# http://www.atlas.cdmx.gob.mx/datosAbiertos/SPC_Encharcamientos_2016.geojson

# Checamos el crs ----
st_crs(delitos)
st_crs(rutas)
st_crs(mpios)
st_crs(edo)

# Checar el tipo de Geometría ----
st_geometry_type(delitos) 
st_geometry_type(edo) 
st_geometry_type(rutas) 

# Hacemos el mapa ----

# Paso 1. Hacer un mapa de cada capa en leaflet
leaflet() %>% 
  addCircleMarkers(data = delitos)

leaflet() %>% 
  addPolylines(data = rutas)

leaflet() %>% 
  addPolygons(data = edo) %>% 
  addPolylines(data = rutas)

# Paso 2: Pegando capas diversas
leaflet() %>% 
  addPolygons(data = mpios) %>% 
  addPolygons(data = edo, color = "black", fill = NA) %>%
  addPolylines(data = rutas, color = "green") %>%
  addCircleMarkers(data = delitos, color = "red", radius = 0.01)
  
# Paso 3. Mapas base

# Ver mapas base disponibles
unlist(leaflet::providers)
# https://leaflet-extras.github.io/leaflet-providers/preview/

# Mapa base default
leaflet(delitos) %>% 
  addTiles() %>% # Mapa base default
  addCircleMarkers()

# CartoDB.Positron
leaflet(rutas) %>% 
  addProviderTiles("CartoDB.Positron") %>% # Capa gris
  addPolylines()

# Otras
leaflet(edo) %>% 
  addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>% 
  addPolygons()

# Paletas de colores
sort(unique(delitos$alcaldia_hechos))
  
# Paleta factor

# Función que devuelve una función
pal <- colorFactor(palette = "magma", 
            domain = delitos$alcaldia_hechos)

# "#005e26"
# pal("IZTAPALAPA")
# R 10 G 20 B 155

pal_num <- colorNumeric(palette = "viridis", 
                        domain = as.numeric(delitos$latitud))

# Resultado de la función paleta
pal_num(as.numeric(delitos$latitud))

# Plasmamos en un mapa: 
leaflet(delitos) %>% 
  addTiles() %>% # Mapa base default
  addCircleMarkers(color = pal_num(as.numeric(delitos$latitud)))
  # addCircleMarkers(color = pal(delitos$alcaldia_hechos))

# Añadimos leyendas de colores
leaflet(delitos) %>% 
  addTiles() %>% # Mapa base default
  # addCircleMarkers(color = pal_num(as.numeric(delitos$latitud)))
  addCircleMarkers(color = pal(delitos$alcaldia_hechos)) %>% 
  addScaleBar(position = "bottomleft") %>% 
  addLegend(position = "bottomright", 
            pal = pal, 
            values = delitos$alcaldia_hechos, 
            title = "<p style = 'text-align:center; 
            color:red; font-family:Arial;'>Alcaldía (hechos)</p>")

# Popups y Labels (tooltips)

# Construimos (con HTML) el contenido de la ventanita 
popup <- paste0("<b>Nombre de la ruta: </b>", rutas$descrip, "<br>",
                "<b>Tipo de transporte: </b>", rutas$tipo_trans , "<br>",
                "<b>Detalle de la ruta: </b>", rutas$detalle , "<br>")

# Construimos (como texto) el contenido de la etiqueta
label_rutas <- paste0("Descripción: ", rutas$descrip)

# Construimos una paleta de colores (podria ser mejor)  
pal_rutas <- colorFactor(palette = "magma", 
                         domain = rutas$tipo_trans, 
                         rev = T)

# Conjuntamos todo en un mapa
m <- leaflet(rutas) %>% 
  addProviderTiles("CartoDB.Positron") %>% # Capa gris
  addPolylines(label = label_rutas, 
               color = pal_rutas(rutas$tipo_trans), 
               popup = popup)

# Imprimimos el resultado
m

popup_delito <- str_c("<b>Alcaldía de los hechos: </b>", delitos$alcaldia_hechos, "<br>", 
               "<b>Categoría del delito: </b>", delitos$categoria_delito, "<br>",
               "<b>Categoría del delito: </b>", delitos$unidad_investigacion
               )

# Mapa final ----
leaflet() %>% 
  addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>% 
  addPolylines(data = rutas, 
               color = "blue", 
               label = label_rutas,
               opacity = 0.5) %>% 
  addCircleMarkers(data = delitos, 
                   color = "red", 
                   opacity= 0.5, 
                   popup = popup_delito,
                   radius = 1) 
  # Guardamos como HTML
saveWidget(m, 
           "pagina_wEb.html", 
           selfcontained = FALSE)

# Imprimimos imagen
webshot("pagina_wEb.html",
        file = "mapa.png",
        cliprect = "viewport")
