# Librerias
library(pacman)
# SI NO SE TIENE INSTALADO, INSTALAR ----
# devtools::install_github('charlie86/spotifyr')
# devtools::install_github("ricardo-bion/ggradar", 
#                          dependencies = TRUE)
p_load(tidyverse, spotifyr, ggradar)


# Página de documentación: https://github.com/charlie86/spotifyr
# Si quieres correr este código, NECESITAS sacar tus llaves privadas de spotify. Para esto, visita esta liga: https://developer.spotify.com/dashboard/login (tienes que tener una cuenta de spotify primero).

# Credenciales
# source("02_Codigo/credenciales.R")
client <- "22da427ecada4573b0_descarga_las_tuyas"
secret <- "2274b63c44e34bc_descarga_las__tuyas"

# Defino mis credenciales en las variables del Sistema
# Esto modifica variables de la sesión de RStudio
Sys.setenv(SPOTIFY_CLIENT_ID = client)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)

# Con las credenciales, genero el token a traves de la funcion del cliente. Este token se genera cada sesión y se ocupa para usar las funciones ---- 
access_token <- get_spotify_access_token()

# Acceso a la información del Musico: 
musico = 'Adrian Barba'

# Obtengo información sobre la música del músico o artista
info_musico <- get_artist_audio_features(musico) %>% 
  as_tibble()

# Obtengo el id del musico
id_artista = unique(info_musico$artist_id)

# Obtengo el id o los ids de los discos
id_albums = unique(info_musico$album_id)

# Obtengo los ids de las canciones
tracks = info_musico %>% 
  select(track_id, track_name) %>% 
  unique()

# Obtengo información del album 1
get_album_data = get_album(id = id_albums[1])

# Obtengo las 10 principales canciones del artista
top_tracks = get_artist_top_tracks(id = id_artista, 
                      market = "MX")
get_artists(ids = id_artista)

# Canciones
info_musico$track_name

# Previews de las canciones (si pones el enlace en tu navegador, vas a escuchar un cachito de la canción)
info_musico$track_preview_url

# Duración del Track (en milisegundos)
info_musico$duration_ms

# Mercados disponibles
info_musico$available_markets[[1]] # De la canción 1
class(info_musico$available_markets)

# Variables cuantitativas de análisis de las canciones
datos_cuanti <- info_musico %>% 
  select(track_name, danceability:tempo) %>% 
  as_tibble()

# Con estos datos, tu puedes ir armando tus análisis de spotify :9
