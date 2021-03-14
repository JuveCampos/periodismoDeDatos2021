
library(sf)
# 1. Podemos leer archivos de internet
mpios <- st_read("https://raw.githubusercontent.com/JuveCampos/mpios.geojson")
# 2. Podemos leer archivos localmente
mpios <- st_read("01_Datos/mpios.geojson")
# 3. Podemos leer shps o kml
alcaldias <- st_read("01_Datos/alcaldias.kml")
# Hay que tener todos los archivos para que funcione
frontera <- st_read("01_Datos/Shape Frontera/Mexico_and_US_Border.shp")

class(mpios)


# Función st_crs()

st_crs(mpios)
# > Coordinate Reference System:
#   User input: WGS 84 

st_crs(alcaldias)
# > Coordinate Reference System:
#   User input: WGS 84 

st_crs(frontera)
# > Coordinate Reference System:
#   User input: WGS 84 


plot(mpios, max.plot = 1)

encharcamientos_2018 <- st_read("http://www.atlas.cdmx.gob.mx/datosAbiertos/SPC_Encharcamientos_2018.geojson")
st_crs(encharcamientos_2018)
# Coordinate Reference System:
#   User input: Mexico ITRF2008 
#   ID["EPSG",6365]]

# Si lo quiero transformar a 4326: 
encharcamientos_2018 <- encharcamientos_2018 %>% 
  st_transform(crs = 4326)





