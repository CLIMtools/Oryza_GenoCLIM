#!/usr/bin/env Rscript

library(DBI)
library(feather)
library(RSQLite)
library(dplyr)

db_file <- "data/geno_data.db"
con <- dbConnect(RSQLite::SQLite(), dbname = db_file)

df <- read_feather("data/Japonica_GEA.feather")
df <- df %>%
  mutate(
      FDR_01 = ifelse(FDR < 0.01, 1, 0),
      FDR_005 = ifelse(FDR < 0.005, 1, 0),
      FDR_001 = ifelse(FDR < 0.001, 1, 0)
  )
dbWriteTable(con, "japonica", df, overwrite=TRUE)

query <- "CREATE INDEX idx_FDR_01_Locus_japonica ON japonica(FDR_01, Locus_ID);"
dbExecute(con, query)
query <- "CREATE INDEX idx_FDR_005_Locus_japonica ON japonica(FDR_005, Locus_ID);"
dbExecute(con, query)
query <- "CREATE INDEX idx_FDR_001_Locus_japonica ON japonica(FDR_001, Locus_ID);"
dbExecute(con, query)

df <- read_feather("data/Indica_GEA.feather")
df <- df %>%
  mutate(
      FDR_01 = ifelse(FDR < 0.01, 1, 0),
      FDR_005 = ifelse(FDR < 0.005, 1, 0),
      FDR_001 = ifelse(FDR < 0.001, 1, 0)
  )
dbWriteTable(con, "indica", df, overwrite=TRUE)
query <- "CREATE INDEX idx_FDR_01_Locus_indica ON indica(FDR_01, Locus_ID);"
dbExecute(con, query)
query <- "CREATE INDEX idx_FDR_005_Locus_indica ON indica(FDR_005, Locus_ID);"
dbExecute(con, query)
query <- "CREATE INDEX idx_FDR_001_Locus_indica ON indica(FDR_001, Locus_ID);"
dbExecute(con, query)

dbDisconnect(con)
