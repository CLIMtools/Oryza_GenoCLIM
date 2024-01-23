#!/usr/bin/env Rscript

library(DBI)
library(RSQLite)
library(data.table)
db_file <- "data/geno_data.db"
con <- dbConnect(RSQLite::SQLite(), dbname = db_file)

query <- "SELECT COUNT(*) FROM japonica WHERE FDR_01 == 1;"
count <- dbGetQuery(con, query)
print(count)
query <- "SELECT COUNT(*) FROM japonica WHERE FDR_01 == 1 AND Locus_ID == 'Os12g0244100';"
count <- dbGetQuery(con, query)
print(count)
query <- "SELECT * FROM japonica WHERE FDR_01 == 1 AND Locus_ID == 'Os12g0244100' LIMIT 10000 OFFSET 0;"
result <- dbGetQuery(con, query)
dt <- as.data.table(result)
print(head(dt))


dbDisconnect(con)