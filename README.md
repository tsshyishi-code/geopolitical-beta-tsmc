# geopolitical-beta-tsmc
# Geopolitical Beta: How U.S. Chip Sanctions Price Into TSMC

**How do financial markets price geopolitical risk — event by event, 
or cumulatively?** This project builds two quantitative tools to answer 
that question using TSMC as the empirical lens, combining a hand-coded 
dataset of 57 U.S. semiconductor sanctions with stock market data and 
Taiwan's geopolitical risk index.

---

## Core Findings

**1. Markets distinguish policy substance from political signaling.**
Investment Restrictions produce the largest negative abnormal returns 
(mean CAR −1.4% in a ±3-day window). Entity List additions have near-zero 
market impact. The market reads what a sanction actually does, not just 
that it exists.

**2. TSMC's Geopolitical Beta has shifted from negative to positive.**
In 2018–2020, rising Taiwan geopolitical risk was associated with TSMC 
underperformance. By 2020–2021, the relationship flipped: geopolitical 
tension became a *premium* for TSMC, reflecting its reframing as a 
strategically irreplaceable asset. This beta compressed to near zero 
during 2022–2024 as risk was fully priced in, before rising again under 
Trump 2.0 escalation.

**3. Geopolitical risk is priced structurally, not event-by-event.**
The absence of significant short-term CAR and the evolution of Geo-Beta 
tell the same story: sanctions accumulate into TSMC's baseline risk 
premium rather than triggering discrete market reactions. This is 
reinforced by field interview evidence showing that Taiwan's mid-tier 
suppliers treat export controls as paperwork compliance — reducing the 
surprise value of each new announcement.

---

## Project Structure
geopolitical-beta-tsmc/
│
├── README.md ← You are here
├── key_findings.md ← 3-minute summary (start here)
│
├── data/
│ └── sanctions_events.csv ← 57 hand-coded sanction events
│
├── policy-analysis/
│ ├── full_paper.pdf ← UChi fellowship paper (Tseng 2026)
│ └── sanctions_codebook.md ← Event classification criteria
│
├── quantitative/
│ ├── 00_config.R ← Central configuration
│ ├── 01_data_pipeline.R ← Data download and cleaning
│ ├── 02_baseline_ols.R ← Original regression, cleaned
│ ├── 03_event_study.R ← Sanction CAR analysis
│ └── 04_geopolitical_beta.R ← Rolling Geo-Beta
│
└── outputs/figures/ ← All charts


## Key Charts

**TSMC Geopolitical Beta (Rolling 12-Month)**
![Geo-Beta](outputs/figures/04_geopolitical_beta.png)

**TSMC CAR by Sanction Type**
![CAR by type](outputs/figures/03_car_by_event_type.png)

**TSMC CAR by Severity Across Event Windows**
![CAR by severity](outputs/figures/03_car_by_severity.png)

---

## Data Sources

| Data | Source |
|---|---|
| TSMC ADR & S&P 500 prices | Yahoo Finance via `quantmod` |
| Taiwan GPR Index (GPRC_TWN) | Caldara & Iacoviello (2022), *American Economic Review* |
| Sanction events | Hand-coded from BIS, Federal Register, White House archives |
| Policy analysis & interviews | Tseng (2026), UChi L.C.K. Fellowship paper |

---

## How to Reproduce

```r
# 1. Install dependencies
install.packages("renv")
renv::restore()

# 2. Place GPR data in data/raw/data_gpr_export.xls
#    Download from: https://www.matteoiacoviello.com/gpr.htm

# 3. Run scripts in order
source("quantitative/01_data_pipeline.R")
source("quantitative/03_event_study.R")
source("quantitative/04_geopolitical_beta.R")
```

---

## Background

This project integrates two prior research components:

- A quantitative finance analysis of TSMC stock returns and the 
  Geopolitical Risk Index (2020–2025)
- A mixed-methods policy paper on Biden-era semiconductor sanctions 
  and Taiwan's dual role as enforcement chokepoint and bypass hub, 
  produced for the University of Chicago L.C.K. Fellowship Program (2026)

The integration reframes both components under a single analytical 
question: *how is geopolitical risk priced?*

---

## Limitations

- Rolling 12-month windows have limited degrees of freedom (df = 10), 
  making individual monthly beta estimates rarely significant at 
  conventional levels. Directional patterns are interpreted rather than 
  point estimates.
- CAR estimates have high cross-event variance due to heterogeneous 
  market conditions across 2018–2026.
- TSMC ADR returns include USD/TWD currency effects not separately 
  controlled for.
- The sanction dataset reflects the author's classification judgment; 
  severity scores are defined in `sanctions_codebook.md`.

---

*Code: R · Data: Yahoo Finance, Caldara & Iacoviello GPR · 
Policy analysis: author's original research*
