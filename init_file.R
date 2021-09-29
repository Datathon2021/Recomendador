data_path <- './data/'
script_path <- './scripts/'
output_path <- './outputs/'


# exploring data ----------------------------------------------------------
library(tidyverse)

metadata <- readr::read_delim(paste(data_path, 'metadata.csv', sep = ""), delim = ';')
metadata <- metadata %>% select( content_id, show_type, category, keywords, audience )
metadata <- metadata[complete.cases(metadata),]


