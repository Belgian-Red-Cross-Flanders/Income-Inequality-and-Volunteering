# 06_correlations.R

source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))


# Load master dataset 
master <- readRDS(here::here("data_clean", "master_dataset.rds"))

# Create output folders
dir.create(here::here("outputs", "correlations"),      recursive = TRUE, showWarnings = FALSE)


#########################
#Analysis 

df_all <- master %>%
  mutate(Panel = "All incomes")

df_low <- master %>%
  filter(Income_level_2 == "Lower income") %>%
  mutate(Panel = "Lower Incomes")

df_high <- master %>%
  filter(Income_level_2 == "Higher income") %>%
  mutate(Panel = "Higher Incomes")

datasets <- list(
  All    = df_all,
  Lower  = df_low,
  Higher = df_high
)

# Inequality variables to correlate with Volunteer_hours
vars <- c("Gini_coefficient", "S90S10", "Palma", "Richest_1")

# Correlation methods
methods <- c("pearson", "spearman")

# Create dataframe
correlations <- list()

# Run correlations
for (group in names(datasets)) {
  data <- datasets[[group]]
  
  for (v in vars) {
    
    if (!v %in% names(data) || all(is.na(data[[v]]))) next
    
    x <- data[[v]]
    y <- data$Volunteer_hours
    
    complete <- complete.cases(x, y)
    x <- x[complete]; y <- y[complete]
    
    if (length(x) < 3) next
    
    for (m in methods) {
      test <- cor.test(x, y, method = m)
      
      correlations[[length(correlations) + 1]] <- data.frame(
        group = group,
        variable = v,
        method = m,
        n = length(x),
        estimate = as.numeric(test$estimate),   # <-- FIXED
        p_value = test$p.value,
        conf_low = ifelse(is.null(test$conf.int), NA, test$conf.int[1]),
        conf_high = ifelse(is.null(test$conf.int), NA, test$conf.int[2])
      )
    }
  }
}
correlations_df <- dplyr::bind_rows(correlations)

write.xlsx(correlations_df, here::here("outputs", "correlations", "Correlations.xlsx"))



