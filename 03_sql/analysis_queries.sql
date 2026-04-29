-- 1. Count transactions by status
SELECT 
    status, 
    COUNT(transaction_id) AS transaction_count
FROM transactions
GROUP BY status;

-- 2. Calculate total captured GMV by merchant
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_captured_gmv
FROM transactions
WHERE status = 'captured'
GROUP BY merchant_name;

-- 3. Show top 10 merchants by captured GMV
SELECT 
    merchant_name, 
    SUM(amount_usd) AS total_captured_gmv
FROM transactions
WHERE status = 'captured'
GROUP BY merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;

-- 4. Show daily GMV and successful transaction count
SELECT 
    transaction_date, 
    SUM(amount_usd) AS daily_gmv, 
    COUNT(transaction_id) AS success_count
FROM transactions
WHERE status = 'captured'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 5. Find merchants with chargeback ratio above 1%
SELECT 
    merchant_name,
    COUNT(CASE WHEN status = 'chargeback' THEN 1 END) * 1.0 / COUNT(*) AS chargeback_ratio
FROM transactions
GROUP BY merchant_name
HAVING chargeback_ratio > 0.01;

-- 6. Find regions with average risk score above 50 and more than 20 transactions
SELECT 
    gateway_region, 
    AVG(risk_score) AS avg_risk, 
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY gateway_region
HAVING avg_risk > 50 AND total_transactions > 20;

-- 7. Find users with 3 or more failed or chargeback transactions on the same day
SELECT 
    user_id, 
    transaction_date, 
    COUNT(*) AS failed_count
FROM transactions
WHERE status IN ('failed', 'chargeback')
GROUP BY user_id, transaction_date
HAVING failed_count >= 3;

-- 8. Show chargeback count, unique affected users, and chargeback amount by merchant
SELECT 
    merchant_name, 
    COUNT(CASE WHEN status = 'chargeback' THEN 1 END) AS chargeback_count,
    COUNT(DISTINCT CASE WHEN status = 'chargeback' THEN user_id END) AS unique_users_affected,
    SUM(CASE WHEN status = 'chargeback' THEN amount_usd ELSE 0 END) AS total_chargeback_amount
FROM transactions
GROUP BY merchant_name;
