/*Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that 
retrieve the users along with the number of products they bought.
Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the 
transaction date.*/
--C1: RANK()
WITH twt_purchase_count AS(
SELECT transaction_date,
user_id,
COUNT(*) AS purchase_count
FROM user_transactions
GROUP BY transaction_date,user_id
),
ranked_purchase_count AS(
SELECT transaction_date,
user_id,
purchase_count,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM twt_purchase_count
)
SELECT transaction_date,
user_id,
purchase_count
FROM ranked_purchase_count
WHERE rank = 1
ORDER BY transaction_date
--C2: RANK()
WITH latest_transactions_cte AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS ranking 
  FROM user_transactions
) 
SELECT 
  transaction_date, 
  user_id,
  COUNT(product_id) AS purchase_count 
FROM latest_transactions_cte 
WHERE ranking = 1
GROUP BY transaction_date,user_id
ORDER BY transaction_date
--C3: MAX()
WITH latest_transactions AS (
    SELECT 
        user_id, 
        MAX(transaction_date) AS latest_date
    FROM user_transactions
    GROUP BY user_id
)
SELECT 
    lt.latest_date AS transaction_date,
    ut.user_id, 
    COUNT(ut.product_id) AS purchase_count
FROM latest_transactions lt
JOIN user_transactions ut 
    ON lt.user_id = ut.user_id 
    AND lt.latest_date = ut.transaction_date
GROUP BY lt.latest_date, ut.user_id
ORDER BY lt.latest_date;
