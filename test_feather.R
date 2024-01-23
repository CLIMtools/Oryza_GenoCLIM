#!/usr/bin/env Rscript
library(feather)
library(data.table)

df <- read_feather("data/Japonica_GEA.feather")
dt <- as.data.table(df)

# Set keys
setkey(dt, Locus_ID, FDR)

# Specify conditions
locus_id <- 'Os12g0244100'
fdr_threshold <- 0.01

# Filter data
dt_filtered <- dt[Locus_ID == locus_id & FDR < fdr_threshold]

