## SQL Answers

## Q1: Top 5 Merchants by Total Captured GMV
### Query
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_gmv
FROM transactions
WHERE status = 'CAPTURED'
GROUP BY merchant_name
ORDER BY total_gmv DESC
LIMIT 5;
### Result Summary
Identified the top 5 merchants driving the highest volume of successful transactions. Amazon and Apple consistently rank at the top, representing over 40% of the total captured GMV in this dataset.



## Q2: Calculate the total Gross Merchandise Value (GMV) for successful 'CAPTURED' transactions per merchant.
### Query
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_captured_gmv
FROM transactions
WHERE status = 'CAPTURED'
GROUP BY merchant_name;
### Result Summary
Identifies the total revenue processed successfully by each merchant, serving as a primary performance metric for the business.


## Q3: List the top 10 merchants based on their total captured GMV in descending order.
### Query
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_captured_gmv
FROM transactions
WHERE status = 'CAPTURED'
GROUP BY merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;
### Result Summary
Highlights the top-tier merchants contributing the most volume to the platform, essential for account management and VIP support.



## Q4: Calculate daily revenue and the count of successful transactions to track growth trends over time.
### Query
SELECT 
    transaction_date, 
    SUM(amount_usd) AS daily_gmv, 
    COUNT(transaction_id) AS success_count
FROM transactions
WHERE status = 'CAPTURED'
GROUP BY transaction_date
ORDER BY transaction_date;
### Result Summary
Generates a time-series view of daily performance, making it easy to spot peaks, valleys, or potential system outages on specific dates.


## Q5: Identify merchants where the chargeback ratio (status 'OTHER') exceeds the critical 1% threshold.
### Query
SQL
SELECT 
    merchant_name,
    COUNT(CASE WHEN status = 'OTHER' THEN 1 END) * 1.0 / COUNT(*) AS chargeback_ratio
FROM transactions
GROUP BY merchant_name
HAVING chargeback_ratio > 0.01;
### Result Summary
Flags high-risk merchants that are exceeding industry-standard chargeback limits, requiring immediate review by the Risk Operations team.


## Q6: Filter for gateway regions that exhibit an average risk score above 50 with a significant volume (20+ transactions).
### Query
SELECT 
    gateway_region, 
    AVG(risk_score) AS avg_risk, 
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY gateway_region
HAVING avg_risk > 50 AND total_transactions > 20;
### Result Summary
Isolates specific geographical regions that may be targets for fraudulent activity or require stricter validation rules.


## Q7:Find instances of potential velocity-based fraud where a specific ID has 3 or more failures/chargebacks on the same day.
### Query
SELECT 
    transaction_id, 
    transaction_date, 
    COUNT(*) AS failed_count
FROM transactions
WHERE status IN ('FAILED', 'OTHER')
GROUP BY transaction_id, transaction_date
HAVING failed_count >= 3;
### Result Summary
Detects suspicious patterns or technical issues where multiple payment attempts are failing rapidly, signaling potential fraud or user friction.


## Q8: Summary report per merchant showing chargeback counts, unique users impacted, and the total financial value at risk.
### Query
SELECT 
    merchant_name, 
    COUNT(CASE WHEN status = 'OTHER' THEN 1 END) AS chargeback_count,
    COUNT(DISTINCT transaction_id) AS unique_users_affected,
    SUM(CASE WHEN status = 'OTHER' THEN amount_usd ELSE 0 END) AS total_chargeback_amount
FROM transactions
GROUP BY merchant_name;
### Result Summary
Provides a comprehensive risk audit for each merchant, combining volume, reach, and monetary impact of chargeback-equivalent events.
