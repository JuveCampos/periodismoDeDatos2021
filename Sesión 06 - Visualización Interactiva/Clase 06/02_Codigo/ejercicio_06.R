# Gráficas en plotly
# Autor: Jorge Juvenal Campos Ferreira

# Opciones
Sys.setlocale("LC_ALL", "es_ES.UTF-8") #mac
# Sys.setlocale("LC_ALL", "Spanish") #windows/linux

# Librerias ----
library(pacman)
p_load(tidyverse, 
       plotly, 
       readxl, 
       scales)

# BASES DE DATOS ----
bd <- read_xlsx("01_Datos/TweetsGobernadores.xlsx")
btc <- read_csv("01_Datos/BTC-USD.csv")

# Replicar una de las tres gráficas de la carpeta "Replicar"

# PISTA: Paleta de colores: (puede ser fill o color, dependiendo de la grafica)
# scale_fill_manual(values = c("pink", 
#                              "orange", 
#                              "brown", 
#                              "blue", 
#                              "purple", 
#                              "yellow", 
#                              "red", 
#                              "green"))
# scale_color_manual(values = c("pink", 
#                              "orange", 
#                              "brown", 
#                              "blue", 
#                              "purple", 
#                              "yellow", 
#                              "red", 
#                              "green"))




# Grafica de barras ----
glimpse(bd)

plt <- bd %>% 
  select(screen_name, text, Partido) %>% 
  group_by(screen_name, Partido) %>% 
  count() %>%
  mutate(texto_ventanita = str_c("Usuario: ", screen_name, "<br>", 
                      "Número de Tweets: ", n, "<br>", 
                      "Partido: ", Partido
  )) %>% 
  ggplot() + 
  aes(x = reorder(screen_name, n), 
      y = n, 
      fill = Partido, 
      text = texto_ventanita) + 
  geom_col() + 
  coord_flip() + 
  scale_fill_manual(values = c("pink",
                               "orange",
                               "brown",
                               "blue",
                               "purple",
                               "yellow",
                               "red",
                               "green")) + 
  labs(title = "Numero de TweetsxGobernador", 
       x = "", 
       y = "") 

ggplotly(plt, tooltip = "text")


# Grafica lineas ----
btc$open2 <- as.numeric(btc$Open)
plt_l <- btc %>% 
  ggplot()+
  geom_line(aes(x =Date, y= open2),size = 1.1)+
  labs(title = "Precio del bitcoin de octubre 2019 a julio 2020",
       x = "Fecha",
       y = "Precio de apertura") +
  theme_minimal()

ggplotly(plt_l)

# Grafica de puntos ----
plt_p <- bd %>% 
  mutate(texto_ventana = str_c("<b>Usuario: </b>", screen_name, "<br>", 
                               "<b>Contenido: </b>", str_wrap(text, 20)
                               )) %>% 
  ggplot(aes(x = created_at, 
             y = screen_name, 
             color = Partido, 
             text = texto_ventana)) +
  geom_point(alpha = 0.5) +
  scale_color_manual(values = c("pink",
                                "orange",
                                "brown",
                                "blue",
                                "purple",
                                "yellow",
                                "red",
                                "green"))

# Generar grafica sin barra de herramientas
ggplotly(plt_p, tooltip = "text") %>%
  config(displayModeBar = F)

px <- ggplotly(plt_p)
class(px)

# Guardado de widgets 
library(htmlwidgets)
saveWidget(px, "grafica_puntos_tweet.html")

