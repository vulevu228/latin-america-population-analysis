# 📊 Latin America & Caribbean Demographic Dynamics (2010 – 2019)

An end-to-end data analytics, engineering, and macroeconomic visualization project built entirely with **R** and the **Tidyverse** ecosystem. This repository transforms raw, multi-sheet World Bank World Development Indicators (WDI) spreadsheet metrics into a production-ready code pipeline.

---

## 🗂️ Data Source & Schema Architecture

Unlike typical text-based tutorials, this project utilizes a native binary data stream as its origin:
* **Source Artifact:** `data/population_latin_america.xlsx` (A Microsoft Excel Spreadsheet containing complex workbook sheets).
* **Target Sheet Extraction:** The pipeline bypasses calculated spreadsheet pivots (such as `Sheet1`) and programmatically targets the raw matrix contained within the **`Data`** tab.
* **Temporal Footprint:** Tracks cross-sectional national headcounts over a ten-year longitudinal scale (2010 to 2019).

---

## 🛠️ Software Stack & Library Architecture

To handle this data ecosystem seamlessly, the script maps out tasks to specific, professional R package frameworks instead of relying on slow base functions or fragile conversion steps:

1. **`readxl`** Used exclusively for native spreadsheet ingestion (`read_xlsx`). This library allows R to directly uncompress and streams-extract precise numerical cell values out of locked `.xlsx` binaries without relying on external system drivers or risky manual CSV conversions.
2. **`tidyverse`** An aggregated meta-framework combining core data science utilities under a single, unified execution environment:
   * **`tidyr`:** Executes matrix normalization using `pivot_longer()`. This converts row-spanning annual variable columns ("wide data") into an atomic, rows-stacked database layout ("long/tidy data").
   * **`dplyr`:** Powers our engineering transformations. Commands like `filter()`, `mutate()`, and `slice_max()` are explicitly called via namespace definitions (e.g., `dplyr::select`) to avoid system conflicts and handle structural workbook footnotes elegantly.
   * **`stringr` & Built-In Text Tooling:** Parsed data keys to clean messy strings (like turning raw text labels like `"2010 [YR2010]"` into pristine chronological integers).
   * **`ggplot2`:** The visualization architecture mapped to the *Grammar of Graphics* standard. It constructs analytical layers, overrides default chart coordinates using `coord_flip()` for long text readability, and exports high-definition prints via `ggsave()`.

---

## 📈 Executive Insights & Discoveries

* **The Demographic Anchors:** By 2019, the aggregate population across tracked countries reached **646.43 million**. **Brazil** ($211.05\text{M}$) and **Mexico** ($127.58\text{M}$) dominate the landscape, accounting for more than half of the region's overall footprint.
* **The Velocity of Small Nations:** While the largest nations dominate in raw volume, smaller island territories and central American nations experienced the highest compounding growth rates. **Belize** led the decade with an explosive aggregate expansion of $\approx 21.05\%$.
* **Macroeconomic Anomalies:** By looking past total aggregate growth, our metrics identified severe volatility patterns. Nations like **Puerto Rico** and **Venezuela** displayed sharp negative growth drop-offs, mapping cleanly to real-world migration patterns and historic shifts.

---

## 📂 Project Tree Structure
```text
latin-america-population-analysis/
├── data/
│   └── population_latin_america.xlsx   
├── plots/                             
│   ├── top_5_population.png
│   ├── population_trends.png
│   ├── fastest_growing.png
│   ├── small_nations_comparison.png
│   ├── net_demographic_shifts.png
│   └── yoy_growth_velocity.png
├── analysis.R                         
└── README.md                          
