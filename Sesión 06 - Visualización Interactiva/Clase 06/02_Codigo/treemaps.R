# Treemap 
# En caso de que no se tenga d3treeR
# devtools::install_github("timelyportfolio/d3treeR")
library(treemapify)
library(tidyverse)
library(highcharter)
library(treemap)
library(d3treeR)

# Llamamos a la base de Pib para cada país del G20, 2018
data(G20)
G20

# Treemap con ggplot
ggplot(G20, aes(area = gdp_mil_usd, 
                fill = region, 
                label = str_c(country, "\n", "$", prettyNum(gdp_mil_usd, big.mark = ",")))) +
  geom_treemap() + 
  geom_treemap_text(colour = "white", 
                    place = "center", 
                    reflow = T, 
                    family = "Arial", 
                    size = 15) +
  labs(fill = "Región/Continente", 
       title = "PIB (Millones de dólares, 2018)") + 
  scale_fill_manual(values = c(wesanderson::wes_palettes$GrandBudapest1, 
                               wesanderson::wes_palettes$Cavalcanti1)) + 
  guides(fill=guide_legend(title.position="top", 
                           title.hjust =0.5), 
         colour=guide_legend(title.position="top", 
                             title.hjust =0.5)) + 
  theme(legend.position = "bottom", 
        plot.title = element_text(hjust = 0.5, face = "bold")) 


# VER: https://rstudio-pubs-static.s3.amazonaws.com/320413_6ab300527e8548b1a3cbd0d4c6200fcc.html
# VER: https://www.datacamp.com/community/tutorials/data-visualization-highcharter-r

G20 = G20 %>% 
  mutate(country_2 = str_c(country, ":  $", prettyNum(gdp_mil_usd, big.mark = ",")))

`PIB en Millones de Dólares` <- treemap(G20, index = c("region", "country_2"), 
                                        vSize = "gdp_mil_usd", vColor = "region")

# Interactivo
d3tree3(`PIB en Millones de Dólares`, celltext = "name")

