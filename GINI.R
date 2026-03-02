rm(list = ls())

library(dplyr)
library(xlsx)
library(ggplot2)
library(ggrepel)


##########################
#IMPORTING
gini <- read.xlsx("Red Cross Gini volunteering research.xlsx", sheetName = "GINI_Analysis", header = TRUE)



##################################
#CLEANING

gini_clean <- gini[1:111, ]
gini_clean <- gini_clean %>%
  rename(
    Gini_coefficient = SI.POV.GINI,
    Volunteer_hours = Number.of.volunteer.hours.per.inhabitant,
    Income_level_4 = income
  ) %>%
  select(Gini_coefficient, Volunteer_hours, Income_level_4)


gini_clean <- gini_clean %>%
  mutate(
    Income_level_2 = recode(Income_level_4,
                     "Low income" = "Lower income",
                     "Lower middle income" = "Lower income",
                     "Upper middle income" = "Higher income",
                     "High income" = "Higher income")
  )

#####################
#Descriptives

#All countries
gini_clean %>%
  summarise(
    n        = sum(!is.na(Gini_coefficient)),
    mean     = mean(Gini_coefficient, na.rm = TRUE),
    sd       = sd(Gini_coefficient, na.rm = TRUE),
    median   = median(Gini_coefficient, na.rm = TRUE),
    p25      = quantile(Gini_coefficient, 0.25, na.rm = TRUE),
    p75      = quantile(Gini_coefficient, 0.75, na.rm = TRUE),
    min      = min(Gini_coefficient, na.rm = TRUE),
    max      = max(Gini_coefficient, na.rm = TRUE)
  )%>%
  as.data.frame

gini_clean %>%
  summarise(
    n        = sum(!is.na(Volunteer_hours)),
    mean     = mean(Volunteer_hours, na.rm = TRUE),
    sd       = sd(Volunteer_hours, na.rm = TRUE),
    median   = median(Volunteer_hours, na.rm = TRUE),
    p25      = quantile(Volunteer_hours, 0.25, na.rm = TRUE),
    p75      = quantile(Volunteer_hours, 0.75, na.rm = TRUE),
    min      = min(Volunteer_hours, na.rm = TRUE),
    max      = max(Volunteer_hours, na.rm = TRUE)
  )%>%
  as.data.frame

#Grouped by income 

# By income group
gini_lower <- gini_clean %>%
  filter(Income_level_2 == "Lower income")

gini_higher <- gini_clean %>%
  filter(Income_level_2 == "Higher income")

gini_clean %>%
  group_by(Income_level_2) %>%
  summarise(
    n        = sum(!is.na(Gini_coefficient)),
    mean     = mean(Gini_coefficient, na.rm = TRUE),
    sd       = sd(Gini_coefficient, na.rm = TRUE),
    median   = median(Gini_coefficient, na.rm = TRUE),
    min      = min(Gini_coefficient, na.rm = TRUE),
    max      = max(Gini_coefficient, na.rm = TRUE)
  )%>%
  as.data.frame

gini_clean %>%
  group_by(Income_level_2) %>%
  summarise(
    n        = sum(!is.na(Volunteer_hours)),
    mean     = mean(Volunteer_hours, na.rm = TRUE),
    sd       = sd(Volunteer_hours, na.rm = TRUE),
    median   = median(Volunteer_hours, na.rm = TRUE),
    min      = min(Volunteer_hours, na.rm = TRUE),
    max      = max(Volunteer_hours, na.rm = TRUE)
  )%>%
  as.data.frame
    


#########################
#Analysis 

# All countries
cor(gini_clean$Gini_coefficient, gini_clean$Volunteer_hours, method = "pearson")
cor.test(gini_clean$Gini_coefficient, gini_clean$Volunteer_hours, method = "pearson")

cor(gini_clean$Gini_coefficient, gini_clean$Volunteer_hours, method = "spearman")
cor.test(gini_clean$Gini_coefficient, gini_clean$Volunteer_hours, method = "spearman")

#Lower income
cor(gini_lower$Gini_coefficient, gini_lower$Volunteer_hours, method = "pearson")
cor.test(gini_lower$Gini_coefficient, gini_lower$Volunteer_hours, method = "pearson")

cor(gini_lower$Gini_coefficient, gini_lower$Volunteer_hours, method = "spearman")
cor.test(gini_lower$Gini_coefficient, gini_lower$Volunteer_hours, method = "spearman")

#Higher income 
cor(gini_higher$Gini_coefficient, gini_higher$Volunteer_hours, method = "pearson")
cor.test(gini_higher$Gini_coefficient, gini_higher$Volunteer_hours, method = "pearson")

cor(gini_higher$Gini_coefficient, gini_higher$Volunteer_hours, method = "spearman")
cor.test(gini_higher$Gini_coefficient, gini_higher$Volunteer_hours, method = "spearman")


#############################
#Figures

#All countries

allcountries <- ggplot(gini_clean, aes(x = Gini_coefficient, y = Volunteer_hours)) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  scale_x_continuous(
    limits = c(25, 65),       # <-- force x-axis to start at 0
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 120),       # <-- force y-axis to start at 0
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
    axis.ticks = element_line(color = "black")
  )

ggsave("gini_all countries.png", plot = allcountries, width = 8, height = 6, dpi = 300)

#High income countries

highcountries <- ggplot(gini_higher, aes(x = Gini_coefficient, y = Volunteer_hours)) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  scale_x_continuous(
    limits = c(25, 65),       # <-- force x-axis to start at 0
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 120),       # <-- force y-axis to start at 0
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
    axis.ticks = element_line(color = "black")
  )

ggsave("gini_high countries.png", plot = highcountries, width = 8, height = 6, dpi = 300)

#Low income countries

lowcountries <- ggplot(gini_lower, aes(x = Gini_coefficient, y = Volunteer_hours)) +
  geom_point(alpha = 0.6, color = "black") +
  geom_smooth(
    method = "lm",
    se = TRUE,
    fullrange = TRUE,
    color = "black",
    fill = "lightblue"
  ) +
  scale_x_continuous(
    limits = c(25, 65),       # <-- force x-axis to start at 0
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 120),       # <-- force y-axis to start at 0
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
    axis.ticks = element_line(color = "black")
  )

ggsave("gini_low countries.png", plot = lowcountries, width = 8, height = 6, dpi = 300)

