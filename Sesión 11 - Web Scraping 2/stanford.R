# Stanford tesis de estadística. 

# Librerias--- 
library(rvest)
library(tidyverse)

# Las consultas van variando en el numero final...
"https://statistics.stanford.edu/people/alumni?page=0"
"https://statistics.stanford.edu/people/alumni?page=1"
"https://statistics.stanford.edu/people/alumni?page=2"
"https://statistics.stanford.edu/people/alumni?page=3"
#...

tabla_total <- data.frame()
for (i in 1:20){
    print(paste0(i, "/20"))
  # Defino una tabla vacia para irla llenando con las demas tablas
    
    # Defino la pagina
    url <- paste0("https://statistics.stanford.edu/people/alumni?page=", i)
    
    # Leo el codigo
    code <- read_html(url)
      
    # Obtengo el nodo de las tablas enteras: 
    tablas <- html_table(code) 
    length(tablas) # Aqui veo que son "n" tablas
    
    # Genero una tabla vacia para irla llenando
    tabla_parcial <- data.frame()
    # Hacemos un loop sobre las tablas
    for (j in length(tablas)){
        tabla_parcial <- rbind.data.frame(tabla_parcial, tablas[[j]])
    }
    
    tabla_total <- rbind.data.frame(tabla_total,tabla_parcial)

}

