#install.packages("renv")
#renv::init()
#install.packages("readr")
#install.packages("dplyr")

library(readr)
library(dplyr)

suspected_factories_2018 <- read_csv("raw/full-info_2018.csv")
suspected_factories_2022 <- read_csv("raw/full-info_202201.csv")

find_duplicates <- function(df){
  df_agg <- df %>% dplyr::group_by(lot_id) %>%
    dplyr::summarize(cnt = n())
  
  dup <- df_agg%>% dplyr::filter(cnt >1) %>% dplyr::select(lot_id)
  return(dup)
}

create_lotid <- function(df){
  
  df$lot_id <- paste(df$行政區, "-", 
        df$地政事務所代碼, "-",
        df$段名, "-",
        df$段號, "-",
        df$地號)
  
  return(df)
}

suspected_factories_2018 <- create_lotid(suspected_factories_2018)
suspected_factories_2022 <- create_lotid(suspected_factories_2022)

#objectives figure out why a lot id might appear in multiple rows 

multiple_entries_2018 <- find_duplicates(suspected_factories_2018)
multiple_entries_2022 <- find_duplicates(suspected_factories_2022)

# this returns 44k 
length(unique(suspected_factories_2018$lot_id))

