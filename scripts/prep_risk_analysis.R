# This script should be run from the directory in which post.nf was launched.
# The purpose of this script is to use prepare tables which can be used within
# the risk analysis.

# import data set
# - QC passes
# - continent is known
# - region is known
# - country is known
# - collection year is known
# - outbreaks collapsed by geographic location and time
# - filtered to genomes predicted as CRAB

rm(list = ls())

library(devtools)
library(dplyr)
load_all("aci")

aci <- read_df(
  "results_redacted/downsample_isolates/aci_crab_ds_geodate2.tsv"
) %>%
  dplyr::filter(filtered & crab & downsampled)

# consistency checks
testthat::expect_equal(sum(is.na(aci$continent)), 0)
testthat::expect_equal(sum(is.na(aci$region23)), 0)
testthat::expect_equal(sum(is.na(aci$country)), 0)
testthat::expect_equal(sum(is.na(aci$collection_year)), 0)
testthat::expect_equal(sum(aci$crab), nrow(aci))

# note, collection_day is already estimated
testthat::expect_equal(sum(is.na(aci$collection_day)), 0)

# filter to ST2
aci_small <- aci[which(aci$mlst == "ST2"),]

if (!dir.exists("data/rr_input_tables")) {
  dir.create("data/rr_input_tables", recursive = TRUE)
}

write.table(
  aci_small,
  file = "data/rr_input_tables/assemblies_for_country_rr.tsv",
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)

# filter to assemblies where city is known
aci_small <- aci_small[which(!is.na(aci_small$city)),]

# filter to assemblies in countries from which we have also collected samples

focus_countries <- c(
  "Bosnia and Herzegovina",
  "Hungary",
  "Romania",
  "Serbia"
)

testthat::expect_true(all(focus_countries %in% aci_small$country))

aci_small <- aci_small |> 
  filter(country %in% focus_countries)

write.table(
  aci_small,
  file = "data/rr_input_tables/assemblies_for_city_rr.tsv",
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)

rm(list = ls())
library(devtools)
library(dplyr)
load_all("aci")

# Prepare assemblies.tsv which contains "lat", "lon" variables

aci <- readRDS("results_redacted/filter_assemblies/aci_filtered.rds")

ACI <- readRDS("data/typing_summary_tables/aci_study_all.rds")

aci <- aci %>% dplyr::filter(filtered) %>% dplyr::filter(mlst == "ST2")

aci$lat <- unname(sapply(aci$assembly, function(x) {
  ACI$lat[which(ACI$assembly == x)]
}))

aci$lon <- unname(sapply(aci$assembly, function(x) {
  ACI$lon[which(ACI$assembly == x)]
}))

write.table(
  aci,
  file = "data/rr_input_tables/assemblies.tsv",
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)
