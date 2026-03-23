# 04_clean_merge.R

# Load helper scripts
source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))

# Clean datasets

#gini

gini_clean <- gini_raw[1:111, ]
gini_clean <- gini_clean %>%
  rename(
    Gini_coefficient = SI.POV.GINI,
    Volunteer_hours = Number.of.volunteer.hours.per.inhabitant,
    Income_level_4 = income
  ) %>%
  select(Country, Gini_coefficient, Volunteer_hours, Income_level_4)

gini_clean$Country <- sapply(gini_clean$Country, standardize_country_name)


gini_clean <- gini_clean %>%
  mutate(
    Income_level_2 = recode(Income_level_4,
                     "Low income" = "Lower income",
                     "Lower middle income" = "Lower income",
                     "Upper middle income" = "Higher income",
                     "High income" = "Higher income")
  )

#s90s10

s90s10_clean <- inequality_raw %>%
  filter(year == 2015) %>%   
  filter(indicators == "S90S10") %>%
  rename(Country = country)%>%
  rename(S90S10 = value) %>%
  select(Country, S90S10)
s90s10_clean$Country <- sapply(s90s10_clean$Country, standardize_country_name)

#palma

palma_clean <- palma_raw %>%
  filter(Year == 2023) %>%
  rename(Palma = Palma.ratio..before.tax...World.Inequality.Database.) %>%
  select(Country, Palma)
palma_clean$Country <- sapply(palma_clean$Country, standardize_country_name)

#richest 1%

richest_clean <- richest_raw %>%
  filter(Year == 2023) %>%
  rename(Richest_1 = Income.share.of.the.richest.1...before.tax...World.Inequality.Database.) %>%
  select(Country, Richest_1)
richest_clean$Country <- sapply(richest_clean$Country, standardize_country_name)

# Merge Datasets

# inequality and gini
inequality_master <- gini_clean %>%
  full_join(s90s10_clean, by = "Country")

#check 
anti_join(
  s90s10_clean %>% distinct(Country),
  inequality_master %>% distinct(Country),
  by = "Country"
)

# inequality and palma
inequality_master <- inequality_master %>%
  full_join(palma_clean, by = "Country")

#check 
anti_join(
  palma_clean %>% distinct(Country),
  inequality_master %>% distinct(Country),
  by = "Country"
)

# inequality and richest 1%
inequality_master <- inequality_master %>%
  full_join(richest_clean, by = "Country")

#check
anti_join(
  richest_clean %>% distinct(Country),
  inequality_master %>% distinct(Country),
  by = "Country"
)

#filter dataset for analysis 
inequality_master <- inequality_master %>% 
  filter(!is.na(Volunteer_hours))
inequality_master <- inequality_master %>%
  select(Country, Income_level_2, Income_level_4, Volunteer_hours, Gini_coefficient, 
         S90S10, Palma, Richest_1)


# -----------------------
# SAVE OUTPUT
# -----------------------

saveRDS(inequality_master, here::here("data_clean", "master_dataset.rds"))
writexl::write_xlsx(inequality_master, here::here("data_clean", "master_dataset.xlsx"))

cat("\nMaster dataset created successfully.")

















