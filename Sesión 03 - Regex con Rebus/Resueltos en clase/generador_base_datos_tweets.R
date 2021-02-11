library(rtweet)
library(tidyverse)
library(rebus)

datos <- search_tweets("izzi", 
              n = 15000, 
              include_rts = FALSE, retryonratelimit = T)
openxlsx::write.xlsx(datos, "tweets_santa_lucia.xlsx")

