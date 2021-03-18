###################################
# Descarga de datos desde RStudio # 
# Jorge Juvenal Campos Ferreira   # 
# Sesión 7 - Vis 2020             #
###################################

# Librerias ----
library(tidyverse)
library(curl)
library(zip)

# Ejemplo 0. Descarga simple. Descarga de datos de Agricultura.

# 1. Ubico los datos de descarga. 
# url donde encuentro los datos: 
#   http://infosiap.siap.gob.mx/gobmx/datosAbiertos_a.php / Producción agrícola
#   http://infosiap.siap.gob.mx/gobmx/datosAbiertos_p.php / Producción pecuaria

# Dato del 2019: 
# http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2019.csv
# http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2018.csv
# http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2017.csv
# http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2016.csv
# http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2015.csv
# http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2014.csv

# ¿Qué varía? 
# AL final de la Url, varia el año de interés. 

# Caso n = 1:
curl::curl_download("http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_2019.csv", 
                    destfile = "01_Datos/datos_agricolas/datos_agricolas_2019.csv")

# Sustituimos la parte variable 
anio = 2019
curl::curl_download(str_c("http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_", anio, ".csv"), 
                    destfile = str_c("01_Datos/datos_agricolas/datos_agricolas_", anio, ".csv"))


# Descarga automatizada: 
for (anio in 2014:2019){
  print(str_c("Se descargaron datos de producción agrícola del ", anio))
  curl::curl_download(str_c("http://infosiap.siap.gob.mx/gobmx/datosAbiertos/ProduccionAgricola/Cierre_agricola_mun_", anio, ".csv"), 
                      destfile = str_c("01_Datos/datos_agricolas/datos_agricolas_", anio, ".csv"))
}


# Ejemplo 1. Descarga de datos del INEGI. ----

# Supongamos que queremos conocer el porcentaje de hogares con Televisión, con los datos del 2020.

# Url de consulta: 
# https://www.inegi.org.mx/programas/ccpv/2020/#Tabulados

# Urls de descarga: 
# https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_mor_16_vivienda.xlsx
# https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_mic_16_vivienda.xlsx
# https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_ags_16_vivienda.xlsx
# https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_chh_16_vivienda.xlsx
# https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_m_oax_16_vivienda.xlsx

# Caso n = 1: 
curl::curl_download(url = "https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_mor_16_vivienda.xlsx", 
                    destfile = 
                      "01_Datos/Datos Censo 2020/HogaresMorelos.xlsx")

# Reemplazamos la parte variable con objetos: 
estado = "mor"
curl::curl_download(url = str_c("https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_", estado, "_16_vivienda.xlsx"), 
                    destfile = 
                      str_c("01_Datos/Datos Censo 2020/Hogares_", estado, ".xlsx"))

# Conseguimos los demas estados: 
edos <- c("ags", "bc", "bcs", "cam","coa", "col","chs", "chh", "cdmx", 
          "dgo", "gto", "gro", "hgo", "jal", "mex", "mic","mor", "nay", "nl", 
          "m_oax", "pue", "qro", "qroo","slp", "sin", "son","tab","tam","tla","ver","yuc","zac")

# Planteamos el loop de descarga: 
for(estado in edos){
  # estado = "ags"
  print(estado)
  curl::curl_download(url = str_c("https://www.inegi.org.mx/contenidos/programas/ccpv/2020/tabulados/cpv2020_b_", estado, "_16_vivienda.xlsx"), 
                      destfile = 
                        str_c("01_Datos/Datos Censo 2020/Hogares_", estado, ".xlsx"))
}


# Ejemplo 2. Descarga de datos del INE. ----

# Url de consulta: 
# https://cartografia.ife.org.mx/sige7/?distritacion=federal

# Enlaces de descarga: 
# https://cartografia.ife.org.mx//descargas/distritacion2017/federal/01/01.zip
# https://cartografia.ife.org.mx//descargas/distritacion2017/federal/02/02.zip
# https://cartografia.ife.org.mx//descargas/distritacion2017/federal/32/32.zip

# Hacemos la primera descarga. 

curl::curl_download(url = "https://cartografia.ife.org.mx//descargas/distritacion2017/federal/01/01.zip",
                    destfile = "01_Datos/Datos INE/01.zip")

zip::unzip("01_Datos/Datos INE/01.zip", 
           exdir = "01_Datos/Datos INE")

# Sustituimos las partes variables por objetos
edo <- "09"
curl::curl_download(url = paste0("https://cartografia.ife.org.mx//descargas/distritacion2017/federal/", edo, "/", edo, ".zip"),
                    destfile = paste0("01_Datos/Datos INE/", edo, ".zip"))
zip::unzip(paste0("01_Datos/Datos INE/", edo, ".zip"), 
           exdir = "01_Datos/Datos INE")

# Generamos el ciclo: 
for (edo in c(str_c("0", 1:9), 10:32)){
  curl::curl_download(url = paste0("https://cartografia.ife.org.mx//descargas/distritacion2017/federal/", edo, "/", edo, ".zip"),
                      destfile = paste0("01_Datos/Datos INE/", edo, ".zip"))
  zip::unzip(paste0("01_Datos/Datos INE/", edo, ".zip"), 
             exdir = "01_Datos/Datos INE")
  print(paste0(edo, "... EXITO!"))
}

# Ejemplo 3. Descarga de datos del SMN-CONAGUA ----
# Queremos bajar los registros de lluvias históricos del SMN. 

# Página de consulta: https://smn.conagua.gob.mx/es/climatologia/informacion-climatologica/informacion-estadistica-climatologica
# Links de descarga de la climatologia diaria: 

# Descarga n = 1
# https://smn.conagua.gob.mx/tools/RESOURCES/Diarios/9051.txt ## Estación Meteorológica Tláhuac. 

# Descarga n = 1
bd <- read_table2("https://smn.conagua.gob.mx/tools/RESOURCES/Diarios/9051.txt", 
                  skip = 20) %>% 
  mutate(Estacion = "9051") # Sacrificamos un renglon :P 

write.csv(bd, file = "01_Datos/Datos Conagua/9051.csv", row.names = F, na = "", fileEncoding = "UTF-8")

# 2. Sustituímos la parte variable por un objeto: 
estacion <- "9051"

bd <- read_table2(paste0("https://smn.conagua.gob.mx/tools/RESOURCES/Diarios/", estacion , ".txt"), 
                  skip = 20) %>% 
  mutate(Estacion = estacion) # Sacrificamos un renglon :P 

write.csv(bd, file = paste0("01_Datos/Datos Conagua/", estacion,".csv"), row.names = F, na = "", fileEncoding = "UTF-8")

# Generamos el loop: 
# Serie: Todos los valores entre el 9001 y el 9100.
serie <- 9001:9100 # No sabemos cuantas estaciones hay... tiramos la apuesta en que hay 100
# No hay 100 estaciones... pero con el código que viene adelante vamos a considerar si hay errores.
# Si no existe el documento, te manda un mensaje de error y sigue adelante
# Esta magia se hace con la función tryCatch()

# Descarga con mensajes de error!
for (estacion in serie){
  
  # Intenta esto...
  tryCatch({
    bd <- read_table2(paste0("https://smn.conagua.gob.mx/tools/RESOURCES/Diarios/", estacion , ".txt"), 
                      skip = 20) %>% 
      mutate(Estacion = estacion) # Sacrificamos un renglon :P 
    
    write.csv(bd, file = paste0("01_Datos/Datos Conagua/", estacion,".csv"), row.names = F, na = "", fileEncoding = "UTF-8")  
  }, 
  # ... y si hay un error, haz esto, ignoralo y sigue adelante :B
  error = function(e){
    print(paste0("Error en la estacion ", estacion))
  })
  
}


# Ejemplo 4. Descarga de datos del COVID. ----
# Descarga automatica de los datos de hoy: 

library(tidyverse)

# Genero la función de descarga. 
# OJOOOO! Esto ya pesa como un giga, cuidado antes de descargar!
descarga <- function(){
  # Nos quedamos la hora local
  hora <- Sys.time() %>% lubridate::hour()
  print(str_c("Ya se calculó la hora: ", hora))
  
  # Definimos el dia sobre el cual vamos a hacer la descarga
  if(hora > 19){
    fecha <- Sys.Date()
  } else {
    fecha <- Sys.Date() - 1
  }
  print(str_c("Ya se calculó la fecha de descarga: ", fecha))
  
  # Generamos el nombre del archivo
  archivo <<- fecha %>%
    as.character() %>%
    as_tibble() %>%
    mutate(anio = "20",
           mes = str_remove_all(string = str_extract(value,
                                                     pattern = "\\-\\d\\d\\-"),
                                pattern = "\\-"),
           dia = str_extract(value,
                             pattern = "\\d\\d$"),
           fecha = str_c(anio,"_", mes,"_", dia,"_", "COVID19MEXICO.csv")) %>% 
    pull(fecha)
  print(str_c("Nombre del archivo construído: ", archivo))
  
  # Descargo el archivo
  curl::curl_download(url = "http://datosabiertos.salud.gob.mx/gobmx/salud/datos_abiertos/datos_abiertos_covid19.zip", 
                      destfile = str_c("01_Datos/Datos Covid/", archivo))
  print("Ya se descargó el archivo más reciente :3")
  
  # Deszipeo el archivo  
  zip::unzip("01_Datos/Datos Covid/datosHoyCovid.zip", 
             exdir = "01_Datos/Datos Covid")
  print("Ya se descomprimió en la carpeta 01_Datos/Datos Covid/")
}

# Llamo a la función (OJO! Tienes que tener espacio en la computadora)
descarga()
