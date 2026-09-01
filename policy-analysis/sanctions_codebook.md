# Sanctions Event Codebook

This codebook defines the classification criteria applied to the 
57 U.S. semiconductor policy events (2018–2026) in 
`data/sanctions_events.csv`. All coding decisions were made by 
the author; ambiguous cases are noted in the dataset's 
`description` field.

---

## Event Types

| Type | Definition | Mechanism |
|---|---|---|
| Export Control | New restrictions on semiconductor technology exports | BIS rule |
| Entity List | Addition of firms to the BIS Entity List or SDN List | Entity list / OFAC |
| Investment Restriction | Limits on U.S. outbound investment in Chinese semiconductor sectors | Executive order |
| Tariff | New or increased tariffs targeting semiconductor products | USTR determination |
| Legislation | Acts of Congress materially affecting semiconductor trade | Legislation |
| Unverified List | Addition of firms to the BIS Unverified List | BIS rule |
| Financial Sanction | Treasury SDN designation of semiconductor-linked entities | OFAC SDN |

---

## Severity Score

Each event is assigned a severity score from 1 to 3 based on the 
directness and breadth of its technological impact on China's 
semiconductor access.

**Score 3 — Direct technology denial**
Directly restricts access to chip manufacturing equipment, EDA 
tools, or high-performance AI chips. These events represent 
genuine chokepoint enforcement targeting irreplaceable 
technologies.

*Examples: Oct 2022 BIS advanced computing rule (S024), 
Oct 2023 export control tightening (S033), 
Apr 2025 NVIDIA H20 export license requirement (S048)*

**Score 2 — Meaningful restriction**
Entity List additions targeting major semiconductor firms, 
significant investment restrictions, or substantial expansions 
of existing controls. These events meaningfully constrain 
China's semiconductor ecosystem without directly severing a 
single critical chokepoint.

*Examples: Huawei Entity List (S008), 
SMIC Entity List (S014),
Aug 2023 executive order on outbound investment (S030)*

**Score 1 — Symbolic or administrative**
Entity List additions targeting peripheral firms, 
administrative clarifications, Unverified List changes, 
or policy actions with limited direct semiconductor impact.

*Examples: Addition of surveillance or aerospace firms with 
indirect semiconductor links, unverified list updates*

---

## Inclusion Criteria

An event is included if it satisfies at least one of the 
following:

- Introduces new export controls on semiconductor technologies
- Adds semiconductor firms to the Entity List or SDN List
- Imposes new licensing requirements on semiconductor exports
- Restricts U.S. outbound investment in semiconductor industries
- Introduces legislation materially affecting semiconductor trade
- Announces tariff changes targeting semiconductor products
- Expands or substantially revises existing semiconductor 
  restrictions

---

## Exclusion Criteria

The following are excluded regardless of media attention:

- Political speeches and statements without binding policy effect
- Rumors and unconfirmed reports
- News reports and analyst commentary
- Proposed but not-yet-implemented policies
- General technology or human rights sanctions without a clear 
  semiconductor nexus
- Broad trade actions where semiconductors are incidental rather 
  than the primary target

---

## Coverage

| Administration | Period | Events |
|---|---|---|
| Trump 1 | Jan 2018 – Jan 2021 | 14 |
| Biden | Jan 2021 – Jan 2025 | 31 |
| Trump 2 | Jan 2025 – Jan 2026 | 12 |
| **Total** | **Jan 2018 – Jan 2026** | **57** |

---

## Notes on Edge Cases

**Permissive events**: S052 (EDA restrictions rescinded, Jul 2025) 
is coded as `direction = permissive` — a policy reversal rather 
than a new restriction. It is retained in the dataset to capture 
the full policy trajectory but is flagged separately in analysis.

**Same-day events**: S011 and S012 (both Aug 17 2020) are treated 
as independent events as they represent distinct policy 
instruments (Entity List addition vs. FDPR expansion) announced 
simultaneously. The shared estimation window is noted as a 
limitation in `key_findings.md`.

**Proposed policies**: S049 (Section 232 investigation, Apr 2025) 
is retained despite being an investigation rather than a final 
rule, on the basis that 232 investigations have historically 
produced binding outcomes and carry credible market signal value. 
This is a judgment call; readers may wish to exclude it in 
robustness checks.

---

*Last updated: 2026 · Author: Tseng Shih-Ying*
