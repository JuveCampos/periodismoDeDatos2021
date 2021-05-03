# Librerias ----
options(scipen = 999)
library(tidyverse)
library(rvest)

# "https://autos.mercadolibre.com.mx/mazda/mazda-3/_Desde_49",
# "https://autos.mercadolibre.com.mx/mazda/mazda-3/_Desde_97",
# "https://autos.mercadolibre.com.mx/mazda/mazda-3/_Desde_145",
# "https://autos.mercadolibre.com.mx/mazda/mazda-3/_Desde_193",

urls_ind = str_c("https://autos.mercadolibre.com.mx/mazda/mazda-3/_Desde_", seq(49, 300, by = 48))


# Página de interés ----
# url = "https://autos.mercadolibre.com.mx/mazda/mazda-3/_Desde_97"

tabla_blanca = tibble()

for(url in urls_ind){
  # Paso 1. Leer el codigo HTML de la pagina que me interesa
  precio <- read_html(url) %>% 
    html_nodes(".price-tag-fraction") %>% 
    html_text() %>% 
    str_remove(pattern = ",") %>% 
    as.numeric()
  
  url = read_html(url) %>% 
    html_node(".ui-search-result__content") %>% 
    html_attr("href")
  
  nombres = read_html(url) %>% 
    html_nodes(".ui-search-item__title") %>% 
    html_text()
  
  # datos = read_html(url) %>% 
  #   html_nodes(".ui-search-card-attributes__attribute") %>% 
  #   html_text()
  
  anios = datos[seq(1,length(datos), by = 2)]
  km = datos[seq(2,length(datos), by = 2)] %>% 
    str_remove(pattern = ",") %>% 
    str_remove(pattern = " Km") %>% 
    as.numeric()
  
  
  tabla = tibble(nombres, precio, anios, km, url)
  
  # Tabla blanca va a tener los pasos de cada una de las iteraciones
  tabla_blanca = rbind(tabla, tabla_blanca)
  
}

# Tabla blanca ----
tabla_blanca

plt = tabla_blanca %>% 
  ggplot(aes(y = precio, x = km)) + 
  geom_point()

plotly::ggplotly(plt)


