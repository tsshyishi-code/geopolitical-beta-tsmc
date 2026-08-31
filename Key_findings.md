# Key Findings — Geopolitical Beta Project
*A 3-minute summary for readers unfamiliar with the methodology*

---

## What This Project Does

This project builds two complementary tools to measure how U.S.-China 
semiconductor sanctions are priced into TSMC's stock:

- **Sanction CAR**: measures TSMC's short-term abnormal return around 
  each of 57 U.S. semiconductor policy events (2018–2026)
- **Geopolitical Beta**: measures how TSMC's long-term sensitivity to 
  Taiwan-specific geopolitical risk has evolved over time

The two tools answer different questions. CAR asks: *does a specific 
policy announcement move TSMC's stock in the next few days?* 
Geo-Beta asks: *is the market becoming structurally more sensitive to 
Taiwan's geopolitical risk over time?*

---

## Finding 1 — Markets distinguish between real and symbolic sanctions

Across 57 sanction events, Investment Restrictions produce the largest 
negative short-term market reaction (mean ±3-day CAR: −1.4%), while 
Entity List additions cluster near zero. Export Controls show a mild 
positive CAR — consistent with markets interpreting chip controls as 
reinforcing TSMC's strategic indispensability to the U.S. supply chain.

Severity-3 sanctions (direct technology denial) are associated with a 
mean ±5-day CAR of −1.51% (t = −1.37, p = 0.19, n = 18). While this 
falls short of conventional significance thresholds — a consequence of 
high cross-event variance and a moderate sample size — the directional 
pattern is consistent across all event windows and sanction types.

**Implication**: Not all sanctions are priced equally. Markets read 
policy substance, not just headlines.

---

## Finding 2 — Geopolitical Beta has gone through three distinct regimes

Using a rolling 12-month regression of TSMC excess returns on Taiwan's 
GPR index (Caldara & Iacoviello), Geo-Beta reveals three structural 
phases:

| Period | Geo-Beta | Interpretation |
|---|---|---|
| 2018–mid 2020 | Negative (≈ −1.0) | Geopolitical risk = revenue threat |
| Mid 2020–2021 | Positive (≈ +0.9), most significant | Geopolitical risk = strategic asset premium |
| 2022–2024 | Near zero | Risk fully priced in; GPR loses marginal explanatory power |
| 2025–2026 | Rising positive (≈ +0.6) | Re-pricing under Trump 2.0 escalation |

The transition from negative to positive beta around mid-2020 coincides 
with the COVID-era recognition of semiconductor supply chain fragility, 
which reframed TSMC from a geopolitical risk-taker to a strategically 
irreplaceable asset.

**Implication**: The *direction* of geopolitical sensitivity matters as 
much as its magnitude. TSMC's market pricing reflects a fundamental 
reframing of what geopolitical risk means for the company.

---

## Finding 3 — Short-term insignificance and long-term structural change are complementary, not contradictory

The absence of statistically significant short-term CAR, combined with 
the structural evolution of Geo-Beta, points to a single coherent 
explanation: **markets price semiconductor sanctions cumulatively and 
structurally, not event-by-event.**

Individual sanctions are absorbed into TSMC's ongoing risk premium 
rather than triggering discrete repricing events. This is consistent 
with field interview evidence from the policy paper component of this 
project, which found that Taiwan's mid-tier semiconductor suppliers 
treat U.S. export controls as compliance paperwork rather than 
operational disruptions — a "gray-zone consensus" that reduces the 
market-moving surprise of each new policy announcement.

**Implication**: Monitoring TSMC's Geo-Beta trajectory is more 
informative for risk assessment than tracking individual sanction 
announcements.

---

## Data & Methods (brief)

| Component | Detail |
|---|---|
| Sanction dataset | 57 events, 2018–2026, hand-coded across Trump 1, Biden, Trump 2 |
| Stock data | TSMC ADR (TSM), S&P 500, daily, Yahoo Finance |
| GPR data | Taiwan GPR (GPRC_TWN), Caldara & Iacoviello (2022) |
| CAR method | Market model, estimation window 120 days, event windows ±1/±3/±5 days |
| Geo-Beta method | Rolling 12-month OLS: excess return ~ Taiwan GPR |

Full methodology and code: see `quantitative/` folder.
