WITH cte1 AS(
SELECT
EXTRACT(YEAR FROM created_at) AS year,
EXTRACT(MONTH FROM created_at) AS month,
category,
SUM(sale_price) OVER(PARTITION BY EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)) AS TPV,
COUNT(DISTINCT order_id) OVER(PARTITION BY EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)) AS TPO,
SUM(cost) OVER(PARTITION BY EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)) AS Total_cost
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id = b.id
)
,cte2 AS (
SELECT
DISTINCT *
FROM cte1)
,cte3 AS 
(SELECT DISTINCT
month,year,TPV,TPO
FROM cte1)
,cte4 AS (
  SELECT *,
  LAG(TPV) OVER(ORDER BY year,month) AS TPV_prev,
  LAG(TPO) OVER(ORDER BY year,month) AS TPO_prev
  FROM cte3
  ORDER BY year,month)
SELECT
a.year || '-' || a.month AS Month,
a.year AS Year,
category AS Product_category,
a.TPV,
a.TPO,
(a.TPV-TPV_prev)*100.0/TPV_prev || '%' AS Revenue_growth,
(a.TPO-TPO_prev)*100.0/TPO_prev || '%' AS Order_growth,
Total_cost,
a.TPV-Total_cost AS Total_profit,
(a.TPV-Total_cost)/Total_cost  AS Profit_to_cost_ratio
FROM cte2 AS a
JOIN cte4 AS b
ON a.month = b.month AND a.year = b.year
ORDER BY a.year,a.month

--C2: Cung giong vay nhung ma trinh bay cac cte de hieu hon
WITH cte1 AS (
  SELECT
  EXTRACT(YEAR FROM created_at) AS year,
  EXTRACT(MONTH FROM created_at) AS month,
  category,
  order_id,
  product_id,
  sale_price,
  cost
  FROM bigquery-public-data.thelook_ecommerce.order_items AS a
  JOIN bigquery-public-data.thelook_ecommerce.products AS b
  ON a.product_id = b.id
),
cte2 AS(
  SELECT
  year,
  month,
  SUM(sale_price) AS TPV,
  COUNT(DISTINCT order_id) AS TPO,
  SUM(cost) AS Total_cost,
  LAG(SUM(sale_price)) OVER(ORDER BY year,month) AS TPV_prev,
  LAG(COUNT(DISTINCT order_id)) OVER(ORDER BY year,month) AS TPO_prev
  FROM cte1
  GROUP BY year,month
),
cte3 AS (
  SELECT DISTINCT year,month,category FROM cte1
)
SELECT
a.year || '-' || a.month AS Month,
a.year AS Year,
category AS Product_category,
TPV,
TPO,
(TPV-TPV_prev)*100.0/TPV_prev || '%' AS Revenue_growth,
(TPO-TPO_prev)*100.0/TPO_prev || '%' AS Order_growth,
Total_cost,
TPV-Total_cost AS Total_profit,
(TPV-Total_cost)/Total_cost AS Profit_to_cost_ratio
FROM cte3 AS a
JOIN cte2 AS b
ON a.year = b.year AND a.month = b.month
ORDER BY a.year,a.month

--Retention Cohort
WITH cohort_index AS(
SELECT
user_id,
FORMAT_TIMESTAMP('%Y-%m',first_date_order) AS cohort_date,
(EXTRACT(YEAR FROM created_at)-EXTRACT(YEAR FROM first_date_order))*12+EXTRACT(MONTH FROM created_at)-EXTRACT(MONTH FROM first_date_order)+1 AS index
FROM (
  SELECT
  user_id,
  created_at,
  MIN(created_at) OVER(PARTITION BY user_id) AS first_date_order
  FROM bigquery-public-data.thelook_ecommerce.orders
)),
xxx AS (
SELECT
cohort_date,
index,
COUNT(DISTINCT user_id) AS count_user
FROM cohort_index
WHERE index <= 4
GROUP BY cohort_date,index)
,ty_le AS (
  SELECT
  cohort_date,
  index,
  ROUND(count_user*100.0/(SELECT count_user FROM xxx WHERE index=1 AND cohort_date = t.cohort_date),2) || '%' AS ty_le
  FROM xxx AS t
)
,customer_cohort AS(
SELECT
cohort_date,
SUM(CASE WHEN index = 1 THEN count_user ELSE 0 END) AS m1,
SUM(CASE WHEN index = 2 THEN count_user ELSE 0 END) AS m2,
SUM(CASE WHEN index = 3 THEN count_user ELSE 0 END) AS m3,
SUM(CASE WHEN index = 4 THEN count_user ELSE 0 END) AS m4
FROM xxx
GROUP BY cohort_date)
--Retention cohort
SELECT
cohort_date,
ROUND(m1*100.0/m1,2) || '%' AS m1,
ROUND(m2*100.0/m1,2) || '%' AS m2,
ROUND(m3*100.0/m1,2) || '%' AS m3,
ROUND(m4*100.0/m1,2) || '%' AS m4
FROM customer_cohort
ORDER BY cohort_date
/* Insight:
Ta thấy hầu như tất cả tỷ lệ khách hàng quay lại sau khi trải nghiệm lần đầu tiền là rất thấp (chủ yếu dưới 10%)
-> có thể do chiến dịch marketing hoặc chương trình khuyến mãi chưa hợp lý, giá cả, chất lượng sản phẩm còn kém
-> daonh nghiệp cần phải xem xét lại chiến dịch market, giá cả cũng như là chất lượng sản phẩm.*/
