# ==============================================================================
# Project: Latin America & Caribbean Population Analysis (2010 - 2019)
# Description: Tidy, analyze, and visualize World Bank demographic trends
# ==============================================================================

# Load required libraries explicitly
library(tidyverse)
library(readxl)

# 1. CREATE DIRECTORIES --------------------------------------------------------
if (!dir.exists("plots")) dir.create("plots")

# 2. LOAD & CLEAN DATA ---------------------------------------------------------
raw_data <- read_xlsx("data/population_latin_america.xlsx", sheet = "Data")

clean_data <- raw_data %>%
  dplyr::filter(!is.na(`Country Code`)) %>%
  dplyr::select(-`Series Name`, -`Series Code`, -contains("..."))

# 3. RESHAPE TO TIDY FORMAT (WIDE TO LONG) -------------------------------------
long_data <- clean_data %>%
  tidyr::pivot_longer(
    cols = starts_with("20"),
    names_to = "Year_Raw",
    values_to = "Population"
  ) %>%
  dplyr::mutate(
    # Bypasses stringr by reading the first 4 characters directly via base R
    Year = as.integer(substr(Year_Raw, 1, 4)), 
    Population_Millions = Population / 1e6
  ) %>%
  dplyr::select(-Year_Raw)

# 4. ORIGINAL DATA VISUALIZATIONS ----------------------------------------------

# Plot 1: Top 5 Most Populous Countries in 2019
top_5_2019 <- long_data %>%
  dplyr::filter(Year == 2019) %>%
  dplyr::slice_max(order_by = Population, n = 5)

p1 <- ggplot(top_5_2019, aes(x = reorder(`Country Name`, Population_Millions), y = Population_Millions)) +
  geom_col(fill = "#2c3e50", width = 0.6) +
  coord_flip() +
  labs(
    title = "Top 5 Most Populous Countries in Latin America & Caribbean (2019)",
    subtitle = "Brazil and Mexico represent the vast majority of the region's headcount.",
    x = NULL, y = "Population (Millions)", caption = "Source: World Development Indicators"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave("plots/top_5_population.png", plot = p1, width = 8, height = 5, dpi = 300)


# Plot 2: Historical Growth Trajectories of the Top 5
trends_top_5 <- long_data %>%
  dplyr::filter(`Country Name` %in% top_5_2019$`Country Name`)

p2 <- ggplot(trends_top_5, aes(x = Year, y = Population_Millions, color = `Country Name`)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  scale_x_continuous(breaks = seq(2010, 2019, by = 2)) +
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Population Growth Trajectories (2010 - 2019)",
    subtitle = "Tracking longitudinal trends of the top 5 largest nations",
    x = "Year", y = "Population (Millions)", color = "Country Name", caption = "Source: World Development Indicators"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

ggsave("plots/population_trends.png", plot = p2, width = 10, height = 6, dpi = 300)


# Plot 3: Top 5 Fastest Growing Populations (%)
growth_rates <- clean_data %>%
  dplyr::mutate(Growth_Pct = ((`2019 [YR2019]` - `2010 [YR2010]`) / `2010 [YR2010]`) * 100) %>%
  dplyr::slice_max(order_by = Growth_Pct, n = 5)

p3 <- ggplot(growth_rates, aes(x = reorder(`Country Name`, Growth_Pct), y = Growth_Pct)) +
  geom_col(fill = "#27ae60", width = 0.6) +
  coord_flip() +
  labs(
    title = "Top 5 Fastest Growing National Populations",
    subtitle = "Total percentage growth change between 2010 and 2019",
    x = NULL, y = "Total Growth Rate (%)", caption = "Source: World Development Indicators"
  ) +
  theme_minimal(base_size = 12)

ggsave("plots/fastest_growing.png", plot = p3, width = 8, height = 5, dpi = 300)


# 5. NEW VISUALIZATIONS FOR GITHUB EXTENSION -----------------------------------

# Plot 4: Highest vs. Lowest Populations (The Extreme Scale Contrast)
extremes_2019 <- long_data %>%
  dplyr::filter(Year == 2019) %>%
  dplyr::arrange(desc(Population)) %>%
  # Grab top 3 and bottom 3 to build a comparative contrast
  dplyr::filter(row_number() <= 3 | row_number() > (n() - 3)) %>%
  dplyr::mutate(Group = ifelse(Population_Millions > 10, "Top 3 Largest", "Bottom 3 Smallest"))

p4 <- ggplot(extremes_2019, aes(x = reorder(`Country Name`, Population), y = Population, fill = Group)) +
  geom_col(width = 0.6) +
  coord_flip() +
  scale_y_log10(labels = scales::comma_format()) + # Using a Log scale to prevent small countries from disappearing
  scale_fill_manual(values = c("Top 3 Largest" = "#c0392b", "Bottom 3 Smallest" = "#2980b9")) +
  labs(
    title = "The Scale Contrast: Largest vs. Smallest Populations (2019)",
    subtitle = "Plotted on a Logarithmic scale to visualize vast demographic disparities side-by-side.",
    x = NULL, y = "Total Population Count (Log Scale)", fill = "Category", caption = "Source: World Development Indicators"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "right")

ggsave("plots/highest_vs_lowest.png", plot = p4, width = 9, height = 5, dpi = 300)


# Plot 5: The "Under 5 Million" Club (Unmasking the Smaller Territories)
small_nations <- long_data %>%
  dplyr::filter(Year == 2019, Population_Millions < 5.0)

p5 <- ggplot(small_nations, aes(x = reorder(`Country Name`, Population_Millions), y = Population_Millions)) +
  geom_col(fill = "#8e44ad", width = 0.7) +
  coord_flip() +
  labs(
    title = "Population Scale Across Smaller Nations & Territories (2019)",
    subtitle = "Isolating regional players with populations under 5 million for balanced comparison.",
    x = NULL, y = "Population (Millions)", caption = "Source: World Development Indicators"
  ) +
  theme_minimal(base_size = 10) # Smaller font to ensure all names fit perfectly

ggsave("plots/small_nations_comparison.png", plot = p5, width = 8, height = 9, dpi = 300)


# 6. ADVANCED MACROECONOMIC METRICS --------------------------------------------

# Plot 6: Net Population Change (Diverging Growth Story)
# This calculates the absolute raw headcount change to see the net scale shifts
net_change <- clean_data %>%
  dplyr::mutate(
    Net_Change_Thousands = (`2019 [YR2019]` - `2010 [YR2010]`) / 1000
  ) %>%
  # Let's look at the top 5 gainers vs anyone who shrank or stagnated
  dplyr::arrange(Net_Change_Thousands) %>%
  dplyr::filter(row_number() <= 5 | row_number() > (n() - 5))

p6 <- ggplot(net_change, aes(x = reorder(`Country Name`, Net_Change_Thousands), y = Net_Change_Thousands, fill = Net_Change_Thousands > 0)) +
  geom_col(width = 0.6) +
  coord_flip() +
  scale_fill_manual(values = c("TRUE" = "#2980b9", "FALSE" = "#c0392b"), guide = "none") +
  labs(
    title = "Net Demographic Shifts (2010 vs 2019)",
    subtitle = "Comparing total headcount changes (in thousands). Red indicates population decline.",
    x = NULL, y = "Net Headcount Change (Thousands)",
    caption = "Source: World Bank WDI"
  ) +
  theme_minimal(base_size = 12)

ggsave("plots/net_demographic_shifts.png", plot = p6, width = 9, height = 5, dpi = 300)


# Plot 7: Year-over-Year Growth Velocity Heatmap
# This calculates percentage change for every single year block
yoy_growth <- clean_data %>%
  tidyr::pivot_longer(cols = starts_with("20"), names_to = "Year_Raw", values_to = "Pop") %>%
  dplyr::mutate(Year = as.integer(substr(Year_Raw, 1, 4))) %>%
  dplyr::group_by(`Country Name`) %>%
  dplyr::arrange(Year) %>%
  # Calculate percentage change from the previous year row
  dplyr::mutate(YoY_Growth = (Pop - dplyr::lag(Pop)) / dplyr::lag(Pop) * 100) %>%
  dplyr::filter(!is.na(YoY_Growth)) %>%
  # Filter for a subset of major countries so the heatmap is readable
  dplyr::filter(`Country Name` %in% c("Brazil", "Mexico", "Colombia", "Argentina", "Peru", 
                                      "Venezuela, RB", "Chile", "Ecuador", "Guatemala", "Cuba", "Puerto Rico"))

p7 <- ggplot(yoy_growth, aes(x = as.factor(Year), y = `Country Name`, fill = YoY_Growth)) +
  geom_tile(color = "white", linewidth = 0.2) +
  scale_fill_gradient2(low = "#e74c3c", mid = "#f1c40f", high = "#27ae60", midpoint = 0.5) +
  labs(
    title = "Year-over-Year Population Growth Velocity",
    subtitle = "Macroeconomic heatmap tracking annual acceleration vs economic/demographic stalls.",
    x = "Year Trajectory", y = NULL, fill = "YoY Growth %",
    caption = "Source: World Bank WDI"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid = element_blank())

ggsave("plots/yoy_growth_velocity.png", plot = p7, width = 10, height = 6, dpi = 300)

cat("Batch complete! 5 advanced portfolio graphics generated inside 'plots/'.\n")