# Librerias ----
library(sf) # Abrir bases de datos geograficas
library(leaflet) # Visualización interactiva (mapas)
library(tidyverse) # Manejo de bases de datos
library(htmlwidgets) # Para guardar paginas HTML
library(webshot) # Para imprimir paginas HTML
library(wesanderson)

# Puntos de delitos en 2018 a Transporte Público
delitos <- st_read("https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/19.%20Urban/roboAPasajerosCDMX.geojson",
                   quiet = T) 

# Rutas de transporte público
rutas <- st_read("https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/19.%20Urban/rutas-y-corredores-del-transporte-publico-concesionado.geojson", quiet = T) %>% 
  st_zm() # Corrección para coordenadas en el eje Z

# Municipios/Alcaldías de la CDMX
mpios <- st_read("https://raw.githubusercontent.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/master/geojsons/Division%20Politica/mpios2.geojson", quiet = TRUE) %>% 
  filter(CVE_ENT == "09")

# Perimetro de la CDMX
edo <- st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/Sin_islas.geojson", quiet = TRUE) %>% 
  filter(ENTIDAD == "CIUDAD DE MÉXICO")

# Verificar que los datos se pudieron leer 
plot(delitos, max.plot = 1)
st_crs(rutas)
# Hay que probar los códigos anteriores con todos los objetos

# Compatibilidad... y si no es crs = 4326?
encharcamientos <- st_read("http://www.atlas.cdmx.gob.mx/datosAbiertos/SPC_Encharcamientos_2018.geojson") %>% 
  st_transform(crs = 4326) # Lo transformamos :3

# Le hacemos pruebas
plot(encharcamientos, max.plot = 1)
st_crs(encharcamientos)

# generamos el label (se activa pasando el cursor)
label <- lapply(str_c("<b style = 'color:green;'>Unidad de investigación: </b><br>", delitos$unidad_investigacion), htmltools::HTML)

# Generamos el popup (se activa con un click)
popup_delitos <- str_c("Mes de los hechos: ", delitos$mes_hechos, "<br>", 
                       "Calle de los hechos: ", delitos$calle_hechos, "<br>",
                       "Alcaldía de los hechos: ", delitos$alcaldia_hechos, "<br>",
                       "Agencia encargada: ", delitos$agencia)

# mes_hechos
# calle_hechos
# alcaldia_hechos
# agencia

# Armamos el mapa (y lo guardamos en un objeto)
m <- leaflet() %>% 
  # addTiles() %>% 
  addProviderTiles(providers$CartoDB.DarkMatter) %>% 
  addPolygons(data = mpios, 
              color = "white",
              # fill = NA, 
              weight = 1) %>%
  # Añadimos las rutas
  addPolylines(data = rutas, 
               color = "blue", 
               opacity = 0.5, 
               weight = 0.5) %>% 
  # Añadimos los puntos hasta arriba
  addCircleMarkers(data = delitos, 
                   color = "yellow", 
                   radius = 3, 
                   opacity = 0.8,
                   label = label,
                   popup = popup_delitos,
                   fillOpacity = 1,
                   weight = 0) 

# Imprimimos el mapa
m

# Lo guardamos en una página web (En la carpeta donde estas trabajando)
# Si no abriste el script desde un proyecto, checa que carpeta es esta con 
# la función getwd()
saveWidget(m, 
           "mapa_delitos_cdmx.html", 
           selfcontained = FALSE)

# Imprimimos imagen desde la página web 
webshot("mapa_delitos_cdmx.html",
        file = "mapa_delitos.png",
        cliprect = "viewport")

# PRÁCTICA CON PALETAS (mira el video para que entiendas que onda)
# Si quieres ver que color es cada uno de estos, visita https://htmlcolors.com/google-color-picker 
# Necesitas que al menos haya un color por cada categoría. 
# Si quieres ver que más paletas hay, checa la presentación

pal <- colorFactor(palette = c("#A42820", "#5F5647", "#9B110E", "#3F5151", "#4E2A1E", "#ffffff",
                               "#0C1707", "#FAD510", "#CB2314", "#273046", "#354823", "#1E1E1E",
                               "#E1BD6D", "#EABE94", "#0B775E", "#35274A", "#F2300F"), 
                   domain = mpios$NOM_MUN)

# Checamos los nombres de las alcaldías
sort(unique(delitos$alcaldia_hechos))

# Armamos el mapa con los nombres de los municipios
leaflet(mpios) %>% 
  addPolygons(fillColor = pal(mpios$NOM_MUN), 
              fillOpacity = 1, 
              label = mpios$NOM_MUN,
              color = "white") %>% 
  addLegend(title = "Nombre de la Alcaldía", 
            opacity = 1,
            pal = pal, 
            values = mpios$NOM_MUN, 
            position = "bottomright")

# EJEMPLO: ARMANDO UN MAPA DE DELITOS POR MUNICIPIO: 

# Acá ponemos un ejemplo práctico de un caso de la vida real. 
# Lo vimos al final de la clase, pero lo terminé. 

# PROBLEMA: Dados los delitos a transporte público, hay que sacar qué alcaldía 
# es la que tiene más delitos y hacer un mapa con esta información. 

# PASOS: 
# 1. Generar la base de datos de atributos. Vamos a contar los puntos de los delitos
# por cada alcaldía. 
# 2. Vamos a localizar la variable llave entre los atributos de (1) y la geometría 
# de los polígonos de municipios. Como no hay clave INEGI vamos a usar los nombres. 
# 3. Con lo que ya sabemos de manejo de texto, stringr, y expresiones regulares, 
# vamos a homologar los nombres de ambas bases para usar los nombres como variable llave. 
# 4. Una vez que ya esta homologada la variable llave en ambos objetos, vamos a usar el 
# merge() o el left_join() para juntar los dos objetos (atributos +  geometrias). 
# 5. Una vez que tenemos el objeto que junta atributos más geometrías, hacemos el 
# mapa usando las funciones de la librería leaflet (como le hicimos arriba).


# 1) Generamos los atributos que necesitamos
# GENERAMOS UNA VARIABLE LLAVE PARA HACER EL MERGE
delitos_por_municipio <- delitos %>% 
  group_by(alcaldia_hechos) %>% 
  count() %>% 
  as_tibble() %>% 
  select(-geometry) %>% 
  arrange(-n) %>% 
  filter(!is.na(alcaldia_hechos)) %>% 
  filter(alcaldia_hechos != "NAUCALPAN DE JUAREZ") %>% 
  mutate(NOM_MUN = str_to_title(alcaldia_hechos))

# Verificamos que los nombres coincidan ----
delitos_por_municipio$NOM_MUN[!( delitos_por_municipio$NOM_MUN %in%  mpios$NOM_MUN)]
mpios$NOM_MUN[!(mpios$NOM_MUN %in% delitos_por_municipio$NOM_MUN)]

# Correccion de nombres de municipios: (homologamos nombres)
delitos_por_municipio <- delitos_por_municipio %>% 
  mutate(NOM_MUN = str_replace_all(NOM_MUN, c("Gustavo A Madero" = "Gustavo A. Madero", 
                                     "Tlahuac" = "Tláhuac", 
                                     "Coyoacan" = "Coyoacán", 
                                     "Cuauhtemoc" =  "Cuauhtémoc", 
                                     "Benito Juarez" = "Benito Juárez", 
                                     "Alvaro Obregon" = "Álvaro Obregón"
                                     )))

# Merge con los municipios 
mapa <- merge(mpios, delitos_por_municipio)
# mapa <- left_join(mpios, delitos_por_municipio) # lo mismo que arriba

# Paleta de colores 
pal_delito <- colorNumeric(domain = mapa$n, 
                           palette = "magma", 
                           reverse = TRUE # Para cambiar el orden de los colores
                           )

# Popup (info con el click)
popup_delitos_alcaldia <- str_c(
  "<b>Alcaldía: </b>", mapa$alcaldia_hechos, "<br>",
  "<b>Delitos registrados: </b>", mapa$n)

# Mapa de delitos a transporte público 
mapa_delitos_en_un_objeto <- leaflet(mapa) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(fillColor = pal_delito(mapa$n), 
              fillOpacity = 1,
              weight = 3,
              color = "gray", 
              label = mapa$NOM_MUN,
              popup = popup_delitos_alcaldia) %>% 
  addLegend(title = "<b style = 'color:red;'>Delitos a<br>Transporte Público</b><br>2018", 
            pal = pal_delito, 
            values = mapa$n, 
            position = "bottomright", 
            labFormat = labelFormat(suffix = " delitos a TP"))

# Imprimimos el mapa
mapa_delitos_en_un_objeto

# Lo guardamos en una página web
saveWidget(mapa_delitos_en_un_objeto, 
           "mapa_delitos_cdmx_alcaldias.html", 
           selfcontained = FALSE)

# Imprimimos imagen
webshot("mapa_delitos_cdmx_alcaldias.html",
        file = "mapa_delitos_poligonos.png",
        cliprect = "viewport")

