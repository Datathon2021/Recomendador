library(tidyverse)

# train data (accounts) ------------------------------------------------------------------------
data_path <- 'C:/Users/gomez/Documents/GitHub/CampusParty_Recomendador/data/'
data <- readr::read_csv(paste(data_path, 'train.csv', sep = ""))
data <- data %>% select(asset_id, account_id, device_type, tunein)
data$account_id %>% summary()
# remover NA's
data <- data[!is.na(data$asset_id),]

# metadata (content) --------------------------------------------------------------------------
metadata <- readr::read_delim(paste(data_path, 'metadata.csv', sep = ""), delim = ';')
metadata <- metadata %>% select( asset_id, content_id ) %>% as.matrix()
row.names(metadata) <- metadata[,'asset_id']


# Funcion para pasar de asset a content -------------------------------------------------------

# asset_id identifica episodios no contenido -> convertir a content_id
# necesito traer el metadata de los contenidos para hace la conversion
# 
data_split <- split(data, data$account_id)
assets.per.account <- data_split %>% map(function(df){df[[1]] %>% unique()})

func.contents <- function(vect){
        # vect: vector con los assets_id unicos del account_id
        # vect2: vector de salida con los content_id correspondientes a los asset_id
        vect2 <- vector(mode = 'numeric', length = length(vect))
        for (i in 1:length(vect)) {
                vect2[i] <- metadata[ as.character(vect[i]), 2 ]
        }        
        unique(vect2) 
}

library(furrr)
plan(multisession, workers = 3)

unicos <- assets.per.account %>% future_map(func.contents)

unicos.length <- unicos %>% map_dbl(function(vect) length(vect))
unicos.length %>% summary()
hist(unicos.length, breaks = 50)

# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   2.000   5.000   8.531  10.000 492.000
# 
# Tal vez podria crear los grupos de similaridad con los usuarios de la mitad superior y ver donde encajan los de menor consumo?
# Busco los usuarios mas cercanos incluso con los que tienen un consumo muy bajo?
#  

# dataframe de perfiles (train data) --------------------------------------------------------------------------

# datos del contenido
load(file = paste(data_path, 'content_data.RData', sep = ""))

#columnas para la matriz de entrenamiento
columnas <- c('account_id',
        content$show_type %>% unique(),
        content$cluster %>% unique(),
        content$audience %>% unique())

accounts_df <- matrix(0, nrow = length(unicos), ncol = length(columnas) ) %>% as.data.frame()
colnames(accounts_df) <- columnas

accounts_df['account_id'] <- names(unicos)

for (i in 1:length(unicos)) {
        for (j in 1:length(unicos[[i]])) {
                unicos[[i]][j]
        }
}