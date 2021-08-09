# La idea de este modelo es:
#       - clasificar el contenido
#       - calcular probabilidad de que un usuario consuma cada tipo de contenido
#         (esto es simplemente un calculo de frecuencias)
#       - dentro de las Xs grupos mas consumidos, cuales son los contenidos mas
#         mas probables? en función a que podría hacer un ranking?

# notas:
#       - el contenido se define por la variable 'content_id'

# Data Cleaning -------------------------------------------------------------------------------

library(tidyverse)

data_path <- 'C:/Users/gomez/Documents/GitHub/CampusParty_Recomendador/data/'
metadata <- readr::read_delim(paste(data_path, 'metadata.csv', sep = ""), delim = ';')
metadata <- metadata %>% select( content_id, show_type, category, keywords, audience )

# looking for Na values
apply(metadata, 2, function(x) sum(is.na(x)))
# category is the only one that's complete
metadata <- metadata[complete.cases(metadata),]

# features per content and features matrix ----------------------------------------------------

# esta funcion obtiene las carqacteristicas de un contenido dado
content_features_func <- function(df_content){
        df_content <- df_content %>% 
                separate_rows(category, sep = "[[:punct:]]") %>% 
                separate_rows(keywords, sep = "[[:punct:]]") %>% 
                select(category, keywords)
        
        keywords <- df_content$keywords %>% unique()
        categories <- df_content$category %>% unique()
        features <- c(keywords, categories)
        
        # eliminar espacios en blanco,acentos y todo a minuscula
        temp <- character()
        for (i in features) {
                i <- gsub("[[:space:]]", "", i) %>% tolower()
                i <- gsub("á", "a", i)
                i <- gsub("é", "e", i)
                i <- gsub("í", "i", i)
                i <- gsub("ó", "o", i)
                i <- gsub("ú", "u", i)
                if(i != ""){ temp <- c(temp, i) }
        }
        features <- temp
        features
}

# content_features_list (Named list): cada elemento de la lista es nombrado por 'content_id' 
# y contiene todas las caracteristicas del contenido en cuestion
library(furrr) # para procesar en paralelo
plan(multisession, workers = 2)
list_df_content <- split(metadata, f = metadata$content_id)
content_features_list <- list_df_content %>% future_map(content_features_func)

# extraer todas las features de la lista para generar una matriz general (wide shape data) 
features <- character()
for (i in 1:length(content_features_list)) {
        features <- c(features, content_features_list[[i]])
}
features <- unique(features) # 
view(features)
# generar matriz de features
features_matrix <- matrix(0, nrow = length(content_features_list), ncol = length(features))
rownames(features_matrix) <- names(content_features_list)
colnames(features_matrix) <- features

for (i in 1:length(content_features_list)) { # recorre la lista. Rows
        for (j in 1:length(content_features_list[[i]]) ) { # recorre el vector. Cols
                features_matrix[ names(content_features_list[i]), content_features_list[[i]][j] ] <- 1
                # print(paste(as.character(i), as.character(j)))        
        }
}


rm(list_df_content, i, j, features, content_features_list, content_features_func, metadata, temp)


# Assessing Clustering Tendency ------------------------------------------------------------------

df <- as.data.frame(features_matrix)

library(clustertend)
# Compute Hopkins statistic for iris dataset
set.seed(123)
hopkins(df, n = nrow(df)-1) 

# $H
# [1] 0.1246792
# Los datos son altamente agrupables! (H < 0.5)
# el calculo toma como 20min. ojo!

# Cuantos grupos tenemos??? (tomando en cuenta todas las caracteristicas)
features_char_matrix <- character()
for (i in 1:nrow(features_matrix)) {
        features_char_matrix <- rbind(features_char_matrix, str_c(features_matrix[i,], collapse = ""))                              
}

length(features_char_matrix %>% unique()) 
# 3937, demasiado grande! cada contenido termina siendo unico en sus caracteristicas

# Cuantos grupos tenemos??? (tomando en cuenta solo las categorias)
metadata$category %>% unique() %>% length()     # 219 categorias (combinadas)

categories <- metadata['category'] %>% 
        separate_rows(category, sep = "[[:punct:]]") %>% 
        unique()

temp <- character()
for (i in categories) {
        i <- i %>% tolower()
        i <- gsub("á", "a", i)
        i <- gsub("é", "e", i)
        i <- gsub("í", "i", i)
        i <- gsub("ó", "o", i)
        i <- gsub("ú", "u", i)
        if(i != ""){ temp <- c(temp, i) }
}
categories <- temp %>% unique()                 # 47 categorías (individuales)
# voy a usar esto como una aproximación al numero de grupos en que podría clasificar el contenido

rm(i,temp,categories, features_char_matrix)

# Compute k-means with k = 100, para ver la evolucion de las distancias
set.seed(123)

library(factoextra)
fviz_nbclust(features_matrix, kmeans, method = "wss", k.max = 100) +
       geom_vline(xintercept = 50, linetype = 2)

# Compute k-means with k = 50
set.seed(123)
km.res <- kmeans(features_matrix, 50, nstart = 25)

content_cluster <- cbind( content_id = row.names(features_matrix), cluster = km.res$cluster)
