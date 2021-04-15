# Extraer nombre y calificacion de una pelicula en IMDB
library(tidyverse)
library(rvest)
library(rebus)

# "https://www.imdb.com/search/keyword/?keywords=terror&ref_=kw_nxt&sort=moviemeter,asc&mode=detail&page=1"
# "https://www.imdb.com/search/keyword/?keywords=terror&ref_=kw_nxt&sort=moviemeter,asc&mode=detail&page=2"
# "https://www.imdb.com/search/keyword/?keywords=terror&ref_=kw_nxt&sort=moviemeter,asc&mode=detail&page=3"
# "https://www.imdb.com/search/keyword/?keywords=terror&ref_=kw_nxt&sort=moviemeter,asc&mode=detail&page=4"

url = "https://www.imdb.com/search/keyword/?keywords=terror&ref_=kw_nxt&sort=moviemeter,asc&mode=detail&page=3"

urls = str_c("https://www.imdb.com/search/keyword/?keywords=terror&ref_=kw_nxt&sort=moviemeter,asc&mode=detail&page=", 1:6)

tibble_en_blanco = tibble()

for (url in urls) {
  html <- read_html(url) 
  
  nombres_pelis = html %>% 
    html_nodes(".lister-list") %>% 
    html_nodes(".lister-item") %>% 
    html_nodes(".lister-item-content") %>% 
    html_nodes("h3") %>% 
    html_nodes("a") %>% 
    html_text()
  
  # calif
  califs <- html %>% 
    html_nodes(".lister-list") %>% 
    html_nodes(".lister-item") %>% 
    html_nodes("div") %>% 
    html_attr("data-value") %>% 
    na.omit() %>% 
    as.numeric()
  
  # Base final de califs 
  datos <-  tibble(nombres_pelis, califs)
  
  tibble_en_blanco = rbind(tibble_en_blanco, datos)
  print(url)
}

tibble_en_blanco %>% 
  ggplot(aes(x = nombres_pelis, y = califs)) + 
  geom_col() + 
  coord_flip()
