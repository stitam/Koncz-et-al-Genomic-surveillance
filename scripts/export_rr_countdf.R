library(dplyr)
rm(list = ls())

rr_global <- readRDS("data/rr_global_no_focus/countlist.rds")$countdf |>
  dplyr::select(
    subsample,
    bootstrap,
    mrca,
    same_country,
    different_country_same_continent,
    different_continent
  )

write.table(
  rr_global,
  file = "data/rr_global_no_focus/countdf_global_no_focus.tsv",
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)

rr_europe <- readRDS("data/rr_global_focus_europe/countlist.rds")$countdf |>
  dplyr::select(
    subsample,
    bootstrap,
    mrca,
    same_country,
    different_country_same_continent,
    different_continent
  )

write.table(
  rr_europe,
  file = "data/rr_global_focus_europe/countdf_global_focus_europe.tsv",
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)

rr_regional <- readRDS("data/rr_regional/countlist.rds")$countdf |>
  dplyr::select(
    subsample,
    bootstrap,
    mrca,
    same_city,
    different_city
  )

write.table(
  rr_regional,
  file = "data/rr_regional/countdf_regional.tsv",
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)

