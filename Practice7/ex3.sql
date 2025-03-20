/*Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.*/
--C1: CTES
WITH twt_rank_user AS(
SELECT user_id,spend,transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rank
FROM transactions
)
SELECT user_id,spend,transaction_date
FROM twt_rank_user
WHERE rank = 3
--C2: SUBQUERIES
SELECT 
  user_id, 
  spend, 
  transaction_date 
FROM (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    ROW_NUMBER() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date) AS rank 
  FROM transactions
) AS trans_num
WHERE rank = 3;
