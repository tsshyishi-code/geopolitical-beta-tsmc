library(tidyverse)
library(zoo)
library(here)
library(ggplot2)
library(lubridate)
install.packages("slider")
library(slider) 

# 1. Load and prepare data 

# Daily prices (built in 03_event_study.R or pipeline)
getSymbols(c("TSM", "^GSPC"),
           from = "2017-12-01",
           to   = "2026-01-31",
           auto.assign = TRUE)

# Build monthly return series
tsm_monthly <- to.monthly(TSM, indexAt = "firstof", OHLC = FALSE)
sp5_monthly <- to.monthly(GSPC, indexAt = "firstof", OHLC = FALSE)

monthly_raw <- data.frame(
  date       = as.Date(index(tsm_monthly)),
  tsm_close  = as.numeric(Ad(tsm_monthly)),
  sp5_close  = as.numeric(Ad(sp5_monthly))
) %>%
  arrange(date) %>%
  mutate(
    tsm_ret    = log(tsm_close / lag(tsm_close)),
    sp5_ret    = log(sp5_close / lag(sp5_close)),
    excess_ret = tsm_ret - sp5_ret
  ) %>%
  filter(!is.na(excess_ret))

# Load GPR data
library(readr)
gpr_raw <- read_csv("Downloads/Copy of data_gpr_export.csv")

# Convert Stata date format to year-month
# The 'month' column = months since Jan 1900
gpr_clean <- gpr_raw %>%
  mutate(date = as.Date(month)) %>%
  filter(
    date >= as.Date("2017-12-01"),
    date <= as.Date("2026-02-01")
  ) %>%
  select(date,
         GPR_global = GPR,
         GPR_taiwan = GPRC_TWN)
# Merge monthly returns with GPR
monthly <- monthly_raw %>%
  mutate(date = floor_date(date, "month")) %>%
  left_join(gpr_clean, by = "date") %>%
  filter(!is.na(GPR_global))

#2. Rolling 12-month Geopolitical Beta 
# For each month t, fit OLS on the preceding 12 months (t-11 to t)
# Extract the GPR coefficient = Geo-Beta for month t
gpr_var <- if ("GPR_taiwan" %in% names(monthly)) "GPR_taiwan" else "GPR_global"
message("Using GPR variable: ", gpr_var)

rolling_beta <- slide_dfr(
  .x        = monthly,
  .f        = function(window_data) {
    
    # Need at least 8 observations for a meaningful regression
    if (nrow(window_data) < 8 || var(window_data[[gpr_var]], na.rm = TRUE) == 0) {
      return(NULL)
    }
    
    formula_str <- paste("excess_ret ~", gpr_var)
    m <- lm(as.formula(formula_str), data = window_data)
    
    coefs   <- summary(m)$coefficients
    beta    <- coefs[gpr_var, "Estimate"]
    se      <- coefs[gpr_var, "Std. Error"]
    p_value <- coefs[gpr_var, "Pr(>|t|)"]
    r2      <- summary(m)$r.squared
    
    tibble(
      date     = max(window_data$date),
      geo_beta = beta,
      se       = se,
      lower    = beta - 1.96 * se,
      upper    = beta + 1.96 * se,
      p_value  = p_value,
      r2       = r2,
      n_obs    = nrow(window_data)
    )
  },
  .before   = 11,    # use 11 prior months + current = 12 months
  .complete = TRUE   # only compute when full window is available
)

# 3. Plot: Geo-Beta over time 

p_beta <- ggplot(rolling_beta, aes(x = date, y = geo_beta)) +
  
  # Zero reference line
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  
  # Confidence band
  geom_ribbon(aes(ymin = lower, ymax = upper),
              fill = "#2c7bb6", alpha = 0.15) +
  
  # Beta line
  geom_line(color = "#2c7bb6", linewidth = 1) +
  
  # Points colored by significance
  geom_point(aes(color = p_value < 0.1), size = 2.5) +
  scale_color_manual(
    values = c("TRUE" = "#d73027", "FALSE" = "#2c7bb6"),
    labels = c("TRUE" = "p < 0.10", "FALSE" = "p ≥ 0.10"),
    name   = NULL
  ) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  
  labs(
    title    = "TSMC Geopolitical Beta (Rolling 12-Month)",
    subtitle = paste0("β from: excess return ~ ", gpr_var,
                      " · higher β = greater geopolitical sensitivity"),
    x        = NULL,
    y        = "Geopolitical Beta (β)",
    caption  = paste0("Source: Yahoo Finance, Caldara & Iacoviello GPR Index\n",
                      "Shaded band = 95% CI · Red points = significant at 10% level")
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold"),
    legend.position = "bottom",
    axis.text.x     = element_text(angle = 45, hjust = 1)
  )

ggsave(here("outputs", "figures", "04_geopolitical_beta.png"),
                 p_beta, width = 10, height = 5.5, dpi = 150)

# 4. Plot: R² over time 
# Shows whether GPR explains more of TSMC's return variance over time
# An rising R² = GPR becoming a more important driver

p_r2 <- ggplot(rolling_beta, aes(x = date, y = r2)) +
  geom_area(fill = "#2c7bb6", alpha = 0.2) +
  geom_line(color = "#2c7bb6", linewidth = 0.9) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title   = "GPR Explanatory Power for TSMC Returns (Rolling R²)",
    subtitle = "Rising R² suggests geopolitical risk is increasingly driving TSMC's excess returns",
    x       = NULL,
    y       = "R² (rolling 12-month)",
    caption = "Source: Yahoo Finance, Caldara & Iacoviello GPR Index"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title  = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave(here("outputs", "figures", "04_r2_over_time.png"),
       p_r2, width = 10, height = 4.5, dpi = 150)
