--1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
SELECT
year || '-' || month AS month_year,
total_order,
total_user
FROM(
  SELECT
  EXTRACT(YEAR FROM created_at) AS year,
  EXTRACT(MONTH FROM created_at) AS month,
  COUNT(order_id) AS total_order,
  COUNT(DISTINCT user_id) AS total_user
  FROM bigquery-public-data.thelook_ecommerce.orders
  WHERE created_at BETWEEN '2019-01-01' AND '2022-05-01'
  GROUP BY EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)
  ORDER BY EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)
)
--Insight: Ta thấy số lượng khách hàng cũng như số lượng đơn hàng trong mỗi tháng đều tăng dần theo thời gian
