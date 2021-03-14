# Librerias ----
library(tidyverse)
library(igraph)
library(networkD3)
library(leaflet)
library(readxl)

# Datos ----
nodes <- read_xlsx("01_Datos/nodos.xlsx")
links <- read_xlsx("01_Datos/links.xlsx")

# Generamos un objeto igraph (almacena info de redes)
network <- graph_from_data_frame(d=links, 
                                 vertices=nodes, 
                                 directed=F) 
class(network)
plot(network)

# Paleta de colores
# colores_de_paleta  <- brewer.pal(3, "Set1") # Vector de colores de la paleta Set1
colores_de_paleta <- c("red", "orange", "salmon")

# Create a vector of color
paleta = colorFactor(palette = colores_de_paleta, domain = nodes$carac)
my_color = paleta(nodes$carac)

# Graficamos la red
plot(network, vertex.color=my_color)

# Red interactiva!!!
p <- simpleNetwork(links, 
                   height="100px", 
                   width="100px",        
                   Source = 1,                 # column number of source
                   Target = 2,                 # column number of target
                   linkDistance = 10,          # distance between node. Increase this value to have more space between nodes
                   charge = -900,              # numeric value indicating either the strength of the node repulsion (negative value) or attraction (positive value)
                   fontSize = 14,              # size of the node names
                   fontFamily = "serif",       # font og node names
                   linkColour = "#666",        # colour of edges, MUST be a common colour for the whole graph
                   nodeColour = c("#69b3a2"),     # colour of nodes, MUST be a common colour for the whole graph
                   opacity = 0.9,              # opacity of nodes. 0=transparent. 1=no transparency
                   zoom = T                    # Can you zoom on the figure?
)

# Imprimimos
p

# Generamos datos compatibles para un force Network ----
# Esto es medio complicado... hay que ponerle atención a todos los componentes.
Links = networkD3::igraph_to_networkD3(network)[[1]]
Nodes = networkD3::igraph_to_networkD3(network)[[2]]
Nodes$group = nodes$carac

# Con forceNetwork

# Funcion para presionarle a algun nodo de interes
MyClickScript <- 'alert("Seleccionaste a  " + d.name + " que esta en la fila " +
       (d.index + 1) +  " de tu dataframe original");'


net = forceNetwork(Links = Links, 
             Nodes = Nodes,
             NodeID = "name",
             Group = "group",
             Value = "value",
             # height="550px", 
             # width="350px",        
             linkDistance = 10,          # distance between node. Increase this value to have more space between nodes
             charge = -900,              # numeric value indicating either the strength of the node repulsion (negative value) or attraction (positive value)
             fontSize = 14, 
             opacity = 0.9,              # opacity of nodes. 0=transparent. 1=no transparency
             linkWidth = JS("function(d) {return d.linkWidth;}"), 
             zoom = T, 
             opacityNoHover = TRUE, 
             clickAction = MyClickScript,
             colourScale = JS('d3.scaleOrdinal().range(["salmon","red","orange"]);'))

# Parche para modificar fuerza de los enlaces
net$x$links$linkWidth <- Links$value

# NOTA PARA MI: Colores en D3: https://www.d3-graph-gallery.com/graph/custom_color.html

net
class(net)

# Guardamos el widget ----
htmlwidgets::saveWidget(net, "net.html")

