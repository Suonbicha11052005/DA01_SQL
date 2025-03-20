/*Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.*/
WITH twt_total_spend AS(
SELECT EXTRACT(YEAR FROM transaction_date) AS year,product_id,
SUM(spend) AS total_spend
FROM user_transactions
GROUP BY product_id,EXTRACT(YEAR FROM transaction_date)
)
SELECT year,product_id,total_spend AS curr_year_spend,
LAG(total_spend) OVER(PARTITION BY product_id ORDER BY year) AS prev_year_spend,
ROUND((total_spend-LAG(total_spend) OVER(PARTITION BY product_id ORDER BY year))/LAG(total_spend) OVER(PARTITION BY product_id ORDER BY year)*100,2) AS yoy_rate
FROM twt_total_spend
