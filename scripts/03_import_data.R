# 03_import_data.R

# Load helper scripts
source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))

##########################
#IMPORTING

#gini
gini_raw <- read.xlsx(here::here("data_raw", "Red Cross Gini volunteering research.xlsx"), sheetName = "GINI_Analysis", header = TRUE)

#richest 1% https://ourworldindata.org/explorers/inequality?tab=table&Data=World+Inequality+Database+%28Incomes+before+tax%29&Indicator=Share+of+the+richest+1%25&country=CHL~BRA~ZAF~USA~FRA~CHN
richest_raw <- read.xlsx(here::here("data_raw", "Richest_1.xlsx"), sheetName = "Richest_1", header = TRUE)

#palma ratio
palma_raw <- read.xlsx(here::here("data_raw", "palma-ratio.xlsx"), sheetName = "palma-ratio", header = TRUE)

# unemployment data
unemployment_raw <- read.xlsx(
  here::here("data_raw", "SDG_0852_SEX_AGE_RT_A_EN.xlsx"),
  sheetName = 1,
  header = FALSE
)

# third pillar dataset
tpt <- read.xlsx(here::here("data_raw", "All variables_thirdpillar.xlsx"), sheetName = "Sheet1", header = TRUE)
