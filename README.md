# 📊 Latin America & Caribbean Demographic Dynamics (2010 – 2019)

An end-to-end data analytics and macroeconomic visualization project built entirely with **R** and the **Tidyverse** ecosystem. This repository transforms raw, unstructured World Bank World Development Indicators (WDI) spreadsheet metrics into production-ready analytical insights regarding regional headcount distribution, longitudinal trajectories, and annual growth velocity.

## 🎯 Project Overview
This repository provides a reproducible programmatic pipeline that replaces standard spreadsheet dependencies (Excel Pivot Tables/Charts) with an immutable, code-driven workflow. By reshaping "wide" multi-year tables into "long" tidy formats, this script unmasks regional trends—such as isolating macro-scale national giants from small island micro-territories—and tracks macroeconomic anomalies across a decade.

---

## 📈 Executive Insights & Key Discoveries

### 1. The Regional Giants
* By 2019, the aggregate population across tracked countries reached **646.43 million**.
* **Brazil** ($211.05\text{M}$) and **Mexico** ($127.58\text{M}$) act as massive demographic anchors, representing over half of the entire region's total headcount. 
* *Portfolio Output:* `plots/top_5_population.png` and `plots/population_trends.png`

### 2. The Velocity of Small Nations
* While the largest nations dominate in raw volume, smaller island territories and central American nations experienced the highest compounding growth rates.
* **Belize** led the decade with an explosive aggregate expansion of $\approx 21.05\%$, followed closely by **Sint Maarten** ($\approx 19.61\%$).
* *Portfolio Output:* `plots/fastest_growing.png` and `plots/small_nations_comparison.png`

### 3. Macroeconomic Anomalies (Net Shifts & Drops)
* Out of all tracked nations, **Puerto Rico** and **Venezuela** displayed highly volatile, negative growth intervals over the decade, reflecting severe out-migration, economic shifts, and natural disasters.
* *Portfolio Output:* `plots/net_demographic_shifts.png` and `plots/yoy_growth_velocity.png`

