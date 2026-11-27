# 04_clean_merge.R

# Load helper scripts
source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))

# Clean datasets

# tpt
tpt_vars <- c(
  "population",
  "participation",
  "Volunteering")

tpt_clean <- tpt %>%
  select(Country, all_of(tpt_vars)) %>%
  mutate(
    across(all_of(tpt_vars), ~ na_if(.x, "")),
    across(all_of(tpt_vars), as.numeric)
  )

tpt_clean$Country <- sapply(
  tpt_clean$Country,
  standardize_country_name
)

# unemployment

unemployment <- unemployment_raw

colnames(unemployment) <- unemployment[6, ]
colnames(unemployment)[8] <- "Notes"

unemployment <- unemployment[-(1:6), ] %>%
  rename(Country = `Reference area`) %>%
  mutate(
    `15+` = as.numeric(`15+`),
    Time = as.numeric(Time)
  ) %>%
  filter(
    Sex == "Total",
    Time %in% 2012:2021
  ) %>%
  select(-Source, -Sex, -`15-24`, -`25+`, -Notes) %>%
  pivot_wider(
    names_from = Time,
    values_from = `15+`
  ) %>%
  mutate(
    unemployment = rowMeans(
      pick(`2012`:`2021`),
      na.rm = TRUE
    )
  ) %>%
  select(Country, unemployment)

unemployment$Country <- sapply(
  unemployment$Country,
  standardize_country_name
)

#gini
gini_clean <- gini_raw[1:111, ]
gini_clean <- gini_clean %>%
  rename(
    Gini_coefficient = SI.POV.GINI,
    Income_level_4 = income
  ) %>%
  select(Country, Gini_coefficient, Income_level_4)

gini_clean$Country <- sapply(gini_clean$Country, standardize_country_name)

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

gini_clean <- gini_clean %>%
  left_join(
    unemployment,
    by = "Country"
  ) %>%
  left_join(
    tpt_clean %>%
      select(
        Country,
        population,
        participation,
        Volunteering
      ),
    by = "Country"
  )

HOURS_PER_FTE <- 40 * 48

gini_clean <- gini_clean %>%
  mutate(
    labour_force_rate = participation / 100,
    employment_rate = labour_force_rate * ((100 - unemployment) / 100),
    
    volunteer_share = Volunteering/100,
    
    # Annual volunteer hours per inhabitant 
    Volunteer_hours =
      volunteer_share *
      employment_rate *
      HOURS_PER_FTE
  )

gini_clean <- gini_clean %>%
  mutate(
    Income_level_2 = recode(Income_level_4,
                            "Low income" = "Lower income",
                            "Lower middle income" = "Lower income",
                            "Upper middle income" = "Higher income",
                            "High income" = "Higher income")
  )

# gini and palma
inequality_master <- gini_clean %>%
  full_join(palma_clean, by = "Country")

# inequality and richest 1%
inequality_master <- inequality_master %>%
  full_join(richest_clean, by = "Country")

#filter dataset for analysis 
inequality_master <- inequality_master %>% 
  filter(!is.na(Volunteer_hours))
inequality_master <- inequality_master %>%
  select(
    Country,
    Income_level_2,
    Income_level_4,
    Volunteer_hours,
    unemployment,
    Gini_coefficient,
    Palma,
    Richest_1,
    population,
    participation,
    Volunteering
  )


# -----------------------
# SAVE OUTPUT
# -----------------------

saveRDS(inequality_master, here::here("data_clean", "master_dataset.rds"))
writexl::write_xlsx(inequality_master, here::here("data_clean", "master_dataset.xlsx"))

cat("\nMaster dataset created successfully.")




