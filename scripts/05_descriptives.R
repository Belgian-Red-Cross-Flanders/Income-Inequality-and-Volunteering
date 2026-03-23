# 05_descriptives.R

source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))

# Load master dataset 
master <- readRDS(here::here("data_clean", "master_dataset.rds"))
dir.create(here::here("outputs", "descriptives"), recursive = TRUE, showWarnings = FALSE)
dir.create(here::here("outputs", "figures"),      recursive = TRUE, showWarnings = FALSE)

#All countries

summary <- master %>%
  summarise(across(
    where(is.numeric),
    list(
      mean   = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd = ~sd(., na.rm = TRUE),
      min    = ~min(., na.rm = TRUE),
      max    = ~max(., na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  ))

summary <- summary %>%
  pivot_longer(
    cols = everything(),
    names_to = "measure",
    values_to = "value"
  )

write.xlsx(summary, here::here("outputs", "descriptives", "Descriptives_All Incomes.xlsx"))

summary_2 <- master %>%
  group_by(Income_level_2) %>%
  summarise(across(
    where(is.numeric),
    list(
      mean   = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd = ~sd(., na.rm = TRUE),
      min    = ~min(., na.rm = TRUE),
      max    = ~max(., na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  ))

summary_2 <- summary_2 %>%
  pivot_longer(
    cols = -Income_level_2,
    names_to = "measure",
    values_to = "value"
  )

write.xlsx(summary_2, here::here("outputs", "descriptives", "Descriptives_2 Income Groups.xlsx"))

summary_4 <- master %>%
  group_by(Income_level_4) %>%
  summarise(across(
    where(is.numeric),
    list(
      mean   = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd = ~sd(., na.rm = TRUE),
      min    = ~min(., na.rm = TRUE),
      max    = ~max(., na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  ))

summary_4 <- summary_4 %>%
  pivot_longer(
    cols = -Income_level_4,
    names_to = "measure",
    values_to = "value"
  )

write.xlsx(summary_4, here::here("outputs", "descriptives", "Descriptives_4 Income Groups.xlsx"))


# Session Information

sink(here::here("outputs", "descriptives", "99_sessionInfo.txt"))
print(sessionInfo())
sink()

message("Descriptives complete. See outputs/descriptives and outputs/figures.")
