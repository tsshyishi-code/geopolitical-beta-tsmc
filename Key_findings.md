# Key Findings — Geopolitical Beta Project
*A short summary for this project*

---

## What This Project Does

This project builds two different yet complementary tools to measure how U.S.-China 
semiconductor sanctions are priced into TSMC's stock:

- **Sanction CAR (Short-term)**: measures TSMC's abnormal return around 
  each of 55 U.S. semiconductor policy events (2018–2026)
- **Geopolitical Beta (Long-term)**: measures how TSMC's stock prices have reacted to 
  Taiwan geopolitical risk over time

These two tools answer different questions. CAR asks: *does a specific 
policy announcement impact TSMC's stock price in the next few days?* 
Geo-Beta asks: *is the market becoming structurally more sensitive to 
Taiwan's geopolitical risk over time?*

---

## Finding 1 — Markets distinguish between real and symbolic sanctions

Across 55 sanction events, Investment Restrictions are associated with the 
largest negative short-term market reaction, with a mean ±3-day CAR of −1.4%. 
In contrast, Entity List additions have almost no market impact. Export Controls 
show a small positive CAR, which may reflect the market’s view that tighter chip 
controls further highlight TSMC’s strategic importance to the U.S. supply chain.

Severity-3 sanctions, which involve direct denial of technology access, are associated 
with a mean ±5-day CAR of −1.51% (t = −1.37, p = 0.19, n = 18). This result is not 
statistically significant at conventional levels, while the negative direction appears 
across all different windows. 

**Implication**: Not all sanctions are priced in the same way. What matters to markets 
is not simply that a sanction was announced, but what it actually changes.

---

## Finding 2 — Geopolitical Beta has gone through three different phases

Using a rolling 12-month regression of TSMC excess returns on Taiwan's 
GPR index (Caldara & Iacoviello), Geo-Beta reveals three structural 
phases:

| Period | Geo-Beta | Interpretation |
|---|---|---|
| 2018–mid 2020 | Negative (≈ −1.0) | Geopolitical risk = revenue threat |
| Mid 2020–2021 | Positive (≈ +0.9), most significant | Geopolitical risk = strategic asset premium |
| 2022–2024 | Near zero | Risk fully priced in; GPR loses marginal explanatory power |
| 2025–2026 | Rising positive (≈ +0.6) | Re-pricing under Trump 2.0 escalation |

The shift from negative to positive beta around mid-2020 coincides with growing 
concerns over the fragility of global semiconductor supply chains during the COVID-19 pandemic. 
As TSMC became more widely seen as a critical part of the global chip supply chain, 
geopolitical risk began to take on a different meaning for the company: from a source 
of vulnerability to part of what made TSMC strategically valuable.

**Implication**: The direction of geopolitical sensitivity matters, not just its magnitude. 
TSMC’s market pricing suggests that the role of geopolitical risk changed as the company 
became increasingly viewed as a strategically critical asset.

---

## Finding 3 — Short-term insignificance and long-term structural change are complementary, not contradictory

The lack of significant CARs, together with the changes in Geo-Beta over time, 
points to a broader pattern: **it seems that markets absorb semiconductor sanctions 
gradually rather than reprice TSMC immediately after each announcement.**

Individual sanctions seem to become part of TSMC’s ongoing risk premium rather 
than causing large, independent market reactions. This is consistent with interview
evidence from author's previous research. Repeated sanctions gradually lose their 
surprise value as companies develop established compliance routines.

**Implication**: For assessing TSMC’s exposure to geopolitical risk, tracking 
the longer-term movement of Geo-Beta may be more informative and useful than 
focusing on the market reaction to any single sanction announcement.

---

## Data & Methods (brief)

| Component | Detail |
|---|---|
| Sanction dataset | 55 events, 2018–2026, hand-coded across Trump 1, Biden, Trump 2 |
| Stock data | TSMC ADR (TSM), S&P 500, daily, Yahoo Finance |
| GPR data | Taiwan GPR (GPRC_TWN), Caldara & Iacoviello (2022) |
| CAR method | Market model, estimation window 120 days, event windows ±1/±3/±5 days |
| Geo-Beta method | Rolling 12-month OLS: excess return ~ Taiwan GPR |

Full methodology and code: see `quantitative/` folder.
