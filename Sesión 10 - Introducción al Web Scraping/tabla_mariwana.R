library(tidyverse)
library(rvest)
library(rebus)

url = "https://en.wikipedia.org/wiki/Legality_of_cannabis"
html = read_html(url)
tabla = html %>% 
  html_table()
tabla_interes = tabla[[1]]
tabla_interes %>% 
  group_by(Recreational) %>% count() %>% 
  arrange(-n)





