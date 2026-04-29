# Part 1: Spreadsheet Cleaning and Business Logic - Summary

## 1. Data Cleaning & Standardization Methodology
To ensure data integrity for downstream analysis, the following cleaning steps were performed on `transactions_raw.csv`:

* **Standardized Merchant Names:** Used `VLOOKUP` against `merchant_master.csv` to replace inconsistent names (e.g., "alpha mart", "ALPHA MART") with standardized titles.
* **Date Normalization:** All transaction dates were formatted to `YYYY-MM-DD`.
* **Status Values:** Cleaned status descriptions to a standard set (e.g., "Captured", "Failed", "Refunded") using Find & Replace.
* **Risk Score Cleaning:** Stripped text prefixes like "score:" and "risk-" from the `risk_score` column to convert them into purely numerical values.
* **Currency Conversion:** Implemented an `INDEX(MATCH)` formula to pull daily exchange rates from `exchange_rates.csv` based on both **Currency** and **Transaction Date**, converting all amounts into a single reporting currency (USD).

## 2. Business Logic Implementation
Two flags were created based on specific organizational rules:

### High Value Flag (`high_value_flag`)
Logic applied to `amount_usd` based on the `gateway_region`:
* **APAC:** > 5,000 USD
* **EU:** > 6,000 USD
* **US:** > 7,000 USD
* **Formula used:** `=IF(AND(Region="APAC", USD_Amt>5000), 1, IF(AND(Region="EU", USD_Amt>6000), 1, IF(AND(Region="US", USD_Amt>7000), 1, 0)))`

### High Risk Flag (`high_risk_flag`)
Logic applied to identify potentially fraudulent or problematic transactions:
* Flagged if `risk_score` >= 70 **OR** if the `status` contained the word "chargeback".
* **Formula used:** `=IF(OR(Risk_Score>=70, ISNUMBER(SEARCH("chargeback", Status))), 1, 0)`

## 3. Key Findings & Deliverables
* **Cleaned Data:** Exported the standardized results to `01_data/processed/cleaned_transactions.csv`.
* **Risk Summary:** Generated a pivot table summary in `01_data/processed/merchant_risk_summary.csv` identifying the total number of high-risk flags per merchant.
* **Workbook:** The full logic, including reference tabs and formulas, is preserved in `02_spreadsheet/spreadsheet_workbook.xlsx`.
