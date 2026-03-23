# 03_import_data.R

# Load helper scripts
source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))

##########################
#IMPORTING

#gini
gini_raw <- read.xlsx(here::here("data_raw", "Red Cross Gini volunteering research.xlsx"), sheetName = "GINI_Analysis", header = TRUE)

#s90s10 https://data-explorer.oecd.org/vis?tm=inequality&pg=0&snb=69&vw=sp&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_WISE_IDD%40DF_IDD&df[ag]=OECD.WISE.INE&df[vs]=1.0&dq=.A.INC_DISP_GINI..._T.METH2012.D_CUR.&pd=2010%2C&to[TIME_PERIOD]=false

data("economic_inequality")
inequality_raw <- economic_inequality

#richest 1% https://ourworldindata.org/explorers/inequality?tab=table&Data=World+Inequality+Database+%28Incomes+before+tax%29&Indicator=Share+of+the+richest+1%25&country=CHL~BRA~ZAF~USA~FRA~CHN

richest_raw <- read.xlsx(here::here("data_raw", "Richest_1.xlsx"), sheetName = "Richest_1", header = TRUE)

#palma ratio
palma_raw <- read.xlsx(here::here("data_raw", "palma-ratio.xlsx"), sheetName = "palma-ratio", header = TRUE)

