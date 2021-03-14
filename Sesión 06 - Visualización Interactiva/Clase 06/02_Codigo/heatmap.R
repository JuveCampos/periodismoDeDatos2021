# Heatmaps en R ----
library(tidyverse)
library(plotly)
library(htmlwidgets)

coches = readxl::read_xlsx("01_Datos/coches.xlsx") %>% 
  mutate(text = str_c("<b>Entidad:</b> ", ent, "<br>", 
                      "<b>Año: </b>", year, "<br>", 
                      "<b>Valor: </b>", prettyNum(round(valor, 2), big.mark = ",")
                      ))


# Version 1
plt_1 <- coches %>% 
  filter(ent != "Nacional") %>% 
  ggplot(aes(x = year, 
             y = valor, 
             group = ent, 
             text = text)) +
  geom_line()

# Convertimos a interactiva
ggplotly(plt_1, tooltip = "text")

# Version 2
plt_2 = coches %>% 
  filter(ent != "Nacional") %>% 
  ggplot(aes(x = year, 
             y = valor, 
             group = ent, 
             text = text)) +
  geom_line() + 
  facet_wrap(~ent, 
             ncol = 4)

# Convertimos a interactiva
ggplotly(plt_2, tooltip = "text")

# Versión 3
density(coches$valor)

# Modificacion de los datos: para que la grafica vaya de antes a despues
coches <- coches %>% 
  mutate(year_factor = factor(year, 
                              levels = rev(unique(coches$year))))

# Grafica ----
plot = coches %>% 
  filter(ent != "Nacional") %>% 
  ggplot(aes(x = ent, 
             y = year_factor, 
             fill = valor, 
             text = text)) + 
  geom_tile(color = "white") + 
  scale_fill_gradientn(colours = viridis::viridis(n = 256), 
                       breaks = c(-100, 0, 100, 200, 300, 400, 500, 600, 700, 800), 
                       labels = c(-100, 0, 100, 200, 300, 400, 500, 600, 700, 800)
                       ) + 
  labs(x = "", y = "",
       caption = "Vehículos por cada mil habitantes\nFuente: INEGI. Estadísticas de vehículos de motor registrados en circulación",
       title = str_wrap(str_c(coches$variable[1]), 50)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5), 
        plot.title = element_text(hjust = 0.5))

plot
# Convertimos a interactivo
plotly::ggplotly(plot, tooltip = "text")

# Guardamos en un objeto 
objeto = plotly::ggplotly(plot, tooltip = "text")

# Guardamos en HTML
saveWidget(objeto, "heatmap.html")
