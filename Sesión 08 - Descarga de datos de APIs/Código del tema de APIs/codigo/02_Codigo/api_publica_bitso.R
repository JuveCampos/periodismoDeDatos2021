
library(httr)
library(jsonlite)
library(tidyverse)

url = "https://api.bitso.com/v3/ticker/"

GET(url, query = list(book = "btc_mxn")) %>% 
  content("text") %>% 
  jsonlite::fromJSON()

url = "https://api.bitso.com/v3/order_book/"
GET(url, query = list(book = "btc_mxn")) %>% 
  content("text") %>% 
  jsonlite::fromJSON()

url = "https://api.bitso.com/v3/trades/"
trades = GET(url, query = list(book = "btc_mxn")) %>% 
  content("text") %>% 
  jsonlite::fromJSON() %>% 
  as_tibble()

