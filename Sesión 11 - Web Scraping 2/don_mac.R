# Codigo para ver articulos de El Financiero. 

# Librerias
library(httr)
library(tidyverse)
library(rvest)

# Cambio del API de EL FINANCIERO (Se accede a el en con el Inspector > Web)
# {"feedOffset":24,"feedSize":12,"includeSections":"\"/opinion/macario-schettino\"","size":12}
# query: {"feedOffset":36,"feedSize":12,"includeSections":"\"/opinion/macario-schettino\"","size":12}
# query: {"feedOffset":48,"feedSize":12,"includeSections":"\"/opinion/macario-schettino\"","size":12}
# query: {"feedOffset":60,"feedSize":12,"includeSections":"\"/opinion/macario-schettino\"","size":12}

# Elemento cambiante
offset = 100

# Bucle de extracción de la información 
datos = lapply(c(0,seq(12,240, by = 12)), function(offset){

  # COnstruccion del Query
    url = str_c("www.elfinanciero.com.mx/pf/api/v3/content/fetch/story-feed-sections?query=%7B%22feedOffset%22%3A", 
                offset,
                "%2C%22feedSize%22%3A12%2C%22includeSections%22%3A%22%5C%22%2Fopinion%2Fmacario-schettino%5C%22%22%2C%22size%22%3A12%7D&d=36&_website=elfinanciero")
    
  # Solicitud al API  
    a = GET(url)
  # Revisamos status de solicitud (200 == Chido)  
    a$status_code
  # Jalamos el contenido de la solicitud
    lista = content(a)
  # Tamaño de elementos por extracción  
    l = length(lista$content_elements)
    
  # Bucle dentro de bucle. Lo anterior sacaba los títulos de cada artículo. 
  # Este jala el texto de cada artículo 
  datos = lapply(1:l, function(l){
    # l = 1
      titulo = lista$content_elements[[l]]$headlines$basic
      # fecha = lista$content_elements[[l]]$created_date
      descripcion = pluck(lista$content_elements[[l]]$description, 1)
      url_articulo = str_c("https://www.elfinanciero.com.mx", lista$content_elements[[l]]$website_url)
      
    # Me quedo con los párrafos  
      texto = read_html(url_articulo) %>% 
        html_nodes("p") %>% 
        html_text() %>% 
        str_c(collapse = "<br>")
    # Me quedo con las fechas  
      tiempo = read_html(url_articulo) %>% 
        html_nodes("time") %>% 
        html_text() %>% 
        pluck(1)
    # Genero la tabla final   
      tab = tibble(titulo, tiempo, descripcion, url_articulo, texto)
      return(tab)
        
    })
    # Junto todos los datos en otra tabla intermedia
   data = do.call(rbind, datos)
   return(data)
    
})

# Tabla Final Final 
bd = do.call(rbind, datos)

