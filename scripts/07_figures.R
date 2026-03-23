# 07_figures.R

source(here::here("scripts", "01_load_packages.R"))
source(here::here("scripts", "02_functions.R"))

# Load master dataset 
master <- readRDS(here::here("data_clean", "master_dataset.rds"))

# Create output folders
dir.create(here::here("outputs", "figures"),      recursive = TRUE, showWarnings = FALSE)

#Figures

plotdata <- bind_rows(df_all, df_low, df_high)

plotdata$Panel <- factor(plotdata$Panel,
                         levels = c("All incomes", "Lower Incomes", "Higher Incomes"))


# Grouping by variable 

# Plot for GINI Coefficient 

gini_panel <- ggplot(
  plotdata,
  aes(x = Gini_coefficient, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  facet_wrap(~ Panel, nrow = 1) + 
  scale_x_continuous(
    limits = c(25, 65),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 120),
    expand = c(0, 0)
  ) +
  labs(
    x = "Gini coefficient",
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    strip.text = element_text(size = 12, face = "bold"),
    panel.spacing = unit(1, "lines")
  )


ggsave(
  here::here("outputs", "figures", "GINI_3Panels.png"),
  plot = gini_panel,
  width = 12,
  height = 4,
  dpi = 300
)



# Plot for S90/S10 

s90s10_panel <- ggplot(
  df_high,
  aes(x = S90S10, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  scale_x_continuous(
    limits = c(5, 30),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 120),
    expand = c(0, 0)
  ) +
  labs(
    x = "S90/S10",
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    strip.text = element_text(size = 12, face = "bold")
  )


ggsave(
  here::here("outputs", "figures", "S90S10_1Panel.png"),
  plot = s90s10_panel,
  width = 4,
  height = 4,
  dpi = 300
)

#Figure for Palma Ratio

palma_panel <- ggplot(
  plotdata,
  aes(x = Palma, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  facet_wrap(~ Panel, nrow = 1) +
  labs(
    x = "Palma ratio",
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    strip.text = element_text(size = 12, face = "bold"),
    panel.spacing = unit(1, "lines")
  )


ggsave(
  here::here("outputs", "figures", "Palma_3Panels.png"),
  plot = palma_panel,
  width = 12,
  height = 4,
  dpi = 300
)


#Figure for Richest 1% Ratio

richest_panel <- ggplot(
  plotdata,
  aes(x = Richest_1, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  facet_wrap(~ Panel, nrow = 1) +
  labs(
    x = "Income share of the richest 1%",
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    strip.text = element_text(size = 12, face = "bold"),
    panel.spacing = unit(1, "lines")
  )


ggsave(
  here::here("outputs", "figures", "Richest_3Panels.png"),
  plot = richest_panel,
  width = 12,
  height = 4,
  dpi = 300
)

## Grouping by income level instead of variable



plot_long <- plotdata %>%
  pivot_longer(
    cols = c(Gini_coefficient, Palma, Richest_1),
    names_to = "measure",
    values_to = "value"
  ) %>%
  mutate(
    measure = factor(
      measure,
      levels = c(
        "Gini_coefficient",
        "Palma",
        "Richest_1"),
      labels = c(
        "Gini coefficient",
        "Palma ratio",
        "Income share richest 1%"
      )
    )
  )

label_df <- plot_long %>%
  group_by(measure) %>%
  summarise(
    x = max(value, na.rm = TRUE),
    y = min(Volunteer_hours, na.rm = TRUE),
    label = first(measure)
  ) %>%
  arrange(measure)

## All i ncomes 

all_panel <- ggplot(
  plot_long,
  aes(x = value, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  facet_wrap(
    ~ measure,
    scales = "free_x",
    nrow = 1,
    strip.position = "bottom"
  ) +
  labs(
    x = NULL,   # remove global x-axis label
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.spacing = unit(1, "lines"),
    strip.background = element_blank(),    # clean the strip
    strip.text = element_text(size = 12, face = "bold"),
    
    # Remove default top strip
    strip.placement = "outside",
    
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black")
  )

ggsave(
  here::here("outputs", "figures", "All incomes_3Panels.png"),
  plot = all_panel,
  width = 12,
  height = 4,
  dpi = 300
)

## Lower incomes 

lower_panel <- ggplot(
  dplyr::filter(plot_long, Panel == "Lower Incomes"),
  aes(x = value, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  facet_wrap(
    ~ measure,
    scales = "free_x",
    nrow = 1,
    strip.position = "bottom"
  ) +
  labs(
    x = NULL,   # remove global x-axis label
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.spacing = unit(1, "lines"),
    strip.background = element_blank(),    # clean the strip
    strip.text = element_text(size = 12, face = "bold"),
    
    # Remove default top strip
    strip.placement = "outside",
    
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black")
  )

ggsave(
  here::here("outputs", "figures", "Lower incomes_3Panels.png"),
  plot = lower_panel,
  width = 12,
  height = 4,
  dpi = 300
)

## Higher incomes 

higher_panel <- ggplot(
  dplyr::filter(plot_long, Panel == "Higher Incomes"),
  aes(x = value, y = Volunteer_hours)
) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  facet_wrap(
    ~ measure,
    scales = "free_x",
    nrow = 1,
    strip.position = "bottom"
  ) +
  labs(
    x = NULL,   # remove global x-axis label
    y = "Number of volunteer hours per inhabitant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.spacing = unit(1, "lines"),
    strip.background = element_blank(),    # clean the strip
    strip.text = element_text(size = 12, face = "bold"),
    
    # Remove default top strip
    strip.placement = "outside",
    
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black")
  )

ggsave(
  here::here("outputs", "figures", "Higher incomes_3Panels.png"),
  plot = higher_panel,
  width = 12,
  height = 4,
  dpi = 300
)
