library(readr)
library(tidyverse)
library(quantmod)
library(broom)
library(ggplot2)
install.packages("here")
library(here)

getSymbols(c("TSM","^GSPC"),
           from="2018-04-15",
           to="2026-03-14",
           auto.assign = TRUE)
prices=data.frame(
  date=index(Ad(TSM)),
  tsm_close=as.numeric(Ad(TSM)),
  sp500_close=as.numeric(Ad(GSPC))
)%>%
  arrange(date)%>%
  mutate(
    tsm_ret=log(tsm_close/lag(tsm_close)),
    sp500_ret=log(sp500_close/lag(sp500_close))
  )%>%
  filter(!is.na(tsm_ret),!is.na(sp500_ret))

sanctions = read_csv("Desktop/geopolitical-beta-tsmc/data:/Event_Category.csv")%>%
  mutate(date=as.Date(date))

compute_car <- function(event_date, prices_df, window, est_window = 120) {
  valid_dates  <- prices_df$date
  event_idx    <- which(valid_dates >= event_date)[1]
  
  if (is.na(event_idx)) {
    return(tibble(window = window, CAR = NA, n_obs = NA, message = "event date out of range"))}
  
  est_end   <- event_idx - 11        
  est_start <- est_end - est_window + 1
  
  if (est_start < 1) {
    return(tibble(window = window, CAR = NA, n_obs = NA, message = "insufficient estimation data"))
  }
  
  est_data <- prices_df[est_start:est_end, ]
  
  market_model <- lm(tsm_ret ~ sp500_ret, data = est_data)
  alpha <- coef(market_model)[1]
  beta  <- coef(market_model)[2]
  
  win_start <- event_idx - window
  win_end   <- event_idx + window
  
  if (win_start < 1 | win_end > nrow(prices_df)) {
    return(tibble(window = window, CAR = NA, n_obs = NA, message = "event window out of range"))
  }
  
  event_data <- prices_df[win_start:win_end, ]
  
  event_data <- event_data %>%
    mutate(
      expected_ret = alpha + beta * sp500_ret,
      AR           = tsm_ret - expected_ret
    )
  
  CAR   <- sum(event_data$AR, na.rm = TRUE)
  n_obs <- nrow(event_data)
  
  return(tibble(window = window, CAR = CAR, n_obs = n_obs, message = "ok"))
}

results_raw <- sanctions %>%
  rowwise() %>%
  mutate(
    res_w1 = list(compute_car(date, prices, window = 1)),
    res_w3 = list(compute_car(date, prices, window = 3)),
    res_w5 = list(compute_car(date, prices, window = 5))
  ) %>%
  ungroup()

results_long <- results_raw %>%
  select(event_id, date, event_type, severity, description,
         res_w1, res_w3, res_w5) %>%
  pivot_longer(
    cols      = starts_with("res_w"),
    names_to  = "window_label",
    values_to = "result"
  ) %>%
  unnest(result) %>%
  filter(message == "ok") %>%   
  mutate(
    window_label = case_when(
      window == 1 ~ "±1 day",
      window == 3 ~ "±3 days",
      window == 5 ~ "±5 days"
    ),
    CAR_pct = CAR * 100 
  )

car_by_type <- results_long %>%
  group_by(event_type, window_label) %>%
  summarise(
    mean_CAR  = mean(CAR_pct, na.rm = TRUE),
    se_CAR    = sd(CAR_pct, na.rm = TRUE) / sqrt(n()),
    n_events  = n(),
    .groups   = "drop"
  ) %>%
  mutate(
    lower = mean_CAR - 1.96 * se_CAR,
    upper = mean_CAR + 1.96 * se_CAR
  )

print(car_by_type)

car_by_severity <- results_long %>%
  mutate(severity_label = paste0("Severity ", severity)) %>%
  group_by(severity_label, window_label) %>%
  summarise(
    mean_CAR = mean(CAR_pct, na.rm = TRUE),
    se_CAR   = sd(CAR_pct, na.rm = TRUE) / sqrt(n()),
    n_events = n(),
    .groups  = "drop"
  ) %>%
  mutate(
    lower = mean_CAR - 1.96 * se_CAR,
    upper = mean_CAR + 1.96 * se_CAR
  )


# --- Plot A: Mean CAR by event type (±3 day window) ---
p_type <- car_by_type %>%
  filter(window_label == "±3 days") %>%
  mutate(
    event_type = recode(event_type,
                        "Export control"         = "Export Control",
                        "Entity list"            = "Entity List",
                        "Investment restriction" = "Investment Restriction",
                        "Tariff"                 = "Tariff",
                        "Legislation"            = "Legislation",
                        "Unverified list"        = "Unverified list"
    ),
    event_type = fct_reorder(event_type, mean_CAR)
  ) %>%
  ggplot(aes(x = event_type, y = mean_CAR,
             ymin = lower, ymax = upper,
             fill = mean_CAR < 0)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_errorbar(width = 0.25, color = "grey40") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  scale_fill_manual(values = c("TRUE" = "#c0392b", "FALSE" = "#2980b9")) +
  coord_flip() +
  labs(
    title    = "TSMC Cumulative Abnormal Return by Sanction Type",
    subtitle = "±3 day event window · market model benchmark · 2018–2026",
    x        = NULL,
    y        = "Mean CAR (%)",
    caption  = "Error bars = 95% CI · Source: Yahoo Finance, author's sanctions dataset"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))
print(p_type)

ggsave(here("outputs", "figures", "03_car_by_event_type.png"),
       p_type, width = 8, height = 5, dpi = 150)

# --- Plot B: CAR by severity across all three windows ---
p_severity <- car_by_severity %>%
  mutate(window_label = factor(window_label,
                               levels = c("±1 day", "±3 days", "±5 days"))) %>%
  ggplot(aes(x = window_label, y = mean_CAR,
             ymin = lower, ymax = upper,
             color = severity_label, group = severity_label)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 3) +
  geom_ribbon(aes(fill = severity_label), alpha = 0.12, color = NA) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  scale_color_manual(values = c(
    "Severity 1" = "#2980b9",
    "Severity 2" = "#e67e22",
    "Severity 3" = "#c0392b"
  )) +
  scale_fill_manual(values = c(
    "Severity 1" = "#2980b9",
    "Severity 2" = "#e67e22",
    "Severity 3" = "#c0392b"
  )) +
  labs(
    title    = "TSMC CAR by Sanction Severity Across Event Windows",
    subtitle = "Severity 3 = direct technology denial · Severity 1 = symbolic/administrative",
    x        = "Event window",
    y        = "Mean CAR (%)",
    color    = NULL,
    fill     = NULL,
    caption  = "Shaded bands = 95% CI · Source: Yahoo Finance, author's sanctions dataset"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title  = element_text(face = "bold"),
    legend.position = "bottom"
  )

ggsave(here("outputs", "figures", "03_car_by_severity.png"),
       p_severity, width = 8, height = 5, dpi = 150)

# --- Plot C: Individual event CAR timeline ---
install.packages("ggrepel")
p_timeline <- results_long %>%
  filter(window_label == "±3 days") %>%
  mutate(
    severity_label = paste0("Severity ", severity),
  ) %>%
  ggplot(aes(x = date, y = CAR_pct, color = severity_label)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey60") +
  geom_segment(aes(xend = date, yend = 0), linewidth = 0.5, alpha = 0.6) +
  geom_point(aes(size = severity), alpha = 0.85) +
  
  scale_color_manual(values = c(
    "Severity 1" = "#2980b9",
    "Severity 2" = "#e67e22",
    "Severity 3" = "#c0392b"
  )) +
  scale_size_continuous(range = c(2, 5), guide = "none") +
  labs(
    title    = "TSMC Abnormal Returns Around U.S. Semiconductor Sanctions",
    subtitle = "Each point = one sanction event · ±3 day CAR · 2018–2026",
    x        = NULL,
    y        = "CAR (%)",
    color    = NULL,
    caption  = "Source: Yahoo Finance, author's sanctions dataset (n=55)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold"),
    legend.position = "bottom"
  )

ggsave(here("outputs", "figures", "03_car_timeline.png"),
       p_timeline, width = 10, height = 6, dpi = 150)

message("✓ Event study complete.")
message("  Hero chart: outputs/figures/03_car_by_event_type.png")
message("  Timeline:   outputs/figures/03_car_timeline.png")
message("  Severity:   outputs/figures/03_car_by_severity.png")
message("  Data:       outputs/car_results_long.csv")
