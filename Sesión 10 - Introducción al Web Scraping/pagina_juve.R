library(tidyverse)
library(rvest)
library(rebus)

# Creamos la url
url <- "https://juvenalcampos.com"

# Extraemos el codigo de la pagina de interes 
html = read_html(url)

# Enlaces 
enlaces = html %>% 
  html_nodes("article") %>% 
  html_nodes("a") %>% 
  html_attr("href")

class(enlaces)
  
enlaces = str_c(url, enlaces)

# Nombres de los articulos 
articulos = html %>% 
  html_nodes("article") %>% 
  html_nodes("a") %>% 
  html_text()

# Extraigo las fechas 
fechas = html %>% 
  html_nodes("article") %>% 
  html_nodes("span") %>% 
  html_text() %>% 
  str_remove_all(pattern = "\n" %R% one_or_more(SPC)) %>% 
  as.Date(format = "%Y-%m-%d")

class(fechas)

# Paso final: ordenar los datos en una tabla 
datos <- tibble(articulos, 
       enlaces, 
       fechas)



