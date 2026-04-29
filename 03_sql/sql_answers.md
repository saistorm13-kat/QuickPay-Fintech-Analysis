# Part 2: SQL Business Analysis - Summary

## 1. Analytical Approach
The SQL analysis was performed using the cleaned dataset generated in Part 1. The primary goal was to extract actionable business insights regarding merchant performance, regional risk, and platform health.

Key technical implementations include:
* **Aggregations:** Used `SUM`, `COUNT`, and `AVG` to track performance metrics like GMV (Gross Merchandise Value) and risk profiles.
* **Conditional Logic:** Utilized `CASE WHEN` statements to isolate specific transaction types (e.g., chargebacks) within a single query.
* **Filtering:** Applied `HAVING` clauses to filter grouped data for high-risk regions and problematic user behavior.

## 2. Business Insights & Logic

### Merchant Performance (Queries 2, 3, & 8)
* **Captured GMV:** We focused strictly on 'captured' status to ensure GMV reflects actual revenue, not just attempted transactions.
* **Chargeback Impact:** By tracking unique users affected by chargebacks, we can distinguish between a systemic merchant issue and a single fraudulent user attacking a store.

### Risk & Fraud Detection (Queries 5, 6, & 7)
* **Chargeback Ratio:** Calculated as (Total Chargebacks / Total Transactions). Any merchant exceeding 1% is flagged for manual review to prevent gateway penalties.
* **Velocity Checks:** Query 7 identifies users with 3+ failures/chargebacks in a single day. This "velocity check" is a standard industry method to detect "card-testing" fraud.
* **Regional Risk:** By filtering for regions with >20 transactions and an average risk score >50, we avoid being misled by small sample sizes (outliers) while identifying high-risk corridors.

### Platform Trends (Query 4)
* **Daily Success Rate:** By comparing daily GMV against successful transaction counts, we can monitor platform stability and identify any technical "dips" in processing efficiency.

## 3. Files in this Directory
* `analysis_queries.sql`: Contains the full executable SQL script for all 8 business questions.
* `sql_answers.md`: This summary of methodology and insights.
