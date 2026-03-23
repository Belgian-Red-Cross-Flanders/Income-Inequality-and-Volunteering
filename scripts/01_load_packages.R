# 01_load_packages.R


# Function to install and load packages
install_and_load <- function(pkg){
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# CRAN packages
packages <- c(
  "dplyr",
  "xlsx",
  "ggplot2",
  "ggrepel",
  "devtools",
  "here",
  "writexl",
  "tidyr"
)

# Install and load CRAN packages
lapply(packages, install_and_load)

# Install and load GitHub package if needed
if (!require("inequalityintsvy")) {
  if (!require("devtools")) install.packages("devtools")
  devtools::install_github("cimentadaj/inequalityintsvy")
  library(inequalityintsvy)
}

library(dplyr)
library(xlsx)
library(ggplot2)
library(ggrepel)
library(devtools)
library(inequalityintsvy)
library(here)
library(writexl)
library(tidyr)