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
--2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
--Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng ( Từ 1/2019-4/2022)
SELECT
year || '-' || month AS month_year,
distinct_users,
average_order_value
FROM(
  SELECT
  EXTRACT(YEAR FROM created_at) AS year,
  EXTRACT(MONTH FROM created_at) AS month,
  COUNT(DISTINCT user_id) AS distinct_users,
  SUM(sale_price)/COUNT(DISTINCT order_id) AS average_order_value
  FROM bigquery-public-data.thelook_ecommerce.order_items
  WHERE created_at BETWEEN '2019-01-01' AND '2022-05-01'
  GROUP BY EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)
  ORDER BY year,month
)
/*Insight:
- Số lượng người dùng tăng đều đặn qua từng tháng trong thời gian 2019-1 đến 2022-4 -> công ty đang rất hiệu quả trong việc
thu hút khách hàng mới hoặc giữ chân khách hàng cũ.
- Giá trị trung bình đơn hàng trong mỗi tháng dao động từ 75 -> 130, tăng giảm bất thường không theo thời gian.
- Giá trị tb của đơn hàng không tăng theo lượng khách hàng
    + 1-2019: số lượgn khách hàng ít nhất (6 người) nhưng giá trị tb lại cao nhất (gần 125) -> có thể là do chiến dịch upsell
    hiệu quả ( thuyết phục khách hàng mua sản phẩm đắt hơn) hoặc có thể đó là lượng khách hàng tiềm năng của công ty (sẵn 
    sàng chi nhiều tiền để mua sản phẩm)
    + 4-2022: số lượng khách hàng nhiều nhất (1203 người) nhưng giá trị tb đơn hàng rất thấp (gần 79) -> có thể do chương
    trình khuyến mãi lớn hoặc do chính sách thay đổi giá hoặc do lượgn khách hàng trong tháng đó có nhiều khách hàng mới 
    chưa sẵn sàng chi nhiều tiền
*/
--3.  Nhóm khách hàng theo độ tuổi
--Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
WITH twt AS(
SELECT 
first_name,
last_name,
gender,
age,
MIN(age) OVER(PARTITION BY gender) AS age_min_gender,
MAX(age) OVER(PARTITION BY gender) AS age_max_gender
FROM bigquery-public-data.thelook_ecommerce.users
WHERE created_at BETWEEN '2019-01-01' AND '2022-05-01')
,user_youngest_oldest_gender AS(
SELECT
first_name,
last_name,
gender,
age,
'youngest' AS tag
FROM twt
WHERE age = age_min_gender
UNION DISTINCT
(SELECT
first_name,
last_name,
gender,
age,
'oldest' AS tag
FROM twt
WHERE age = age_MAX_gender))
SELECT
gender,
tag,
age,
COUNT(*) AS so_luong
FROM user_youngest_oldest_gender
GROUP BY gender,tag,age
/*
Gioi tinh MALE: tre nhat 12 so luong 444
                lon nhat 70 so luong 447
Gioi tinh FEMALE: tre nhat 12 so luong 463
                  lon nhat 70 so luong 460*/
--4.Top 5 sản phẩm mỗi tháng.
--Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
WITH sale_cost_per_month_product AS(
SELECT
EXTRACT(YEAR FROM created_at) AS year,
EXTRACT(MONTH FROM created_at) AS month, 
product_id,
name,
SUM(sale_price) OVER(PARTITION BY product_id,EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)) AS sales,
cost*COUNT(*) OVER(PARTITION BY product_id,EXTRACT(YEAR FROM created_at),EXTRACT(MONTH FROM created_at)) AS cost
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id = b.id)
,ranked_profit_per_month AS(
SELECT
*,
sales-cost AS profit,
DENSE_RANK() OVER(PARTITION BY year,month ORDER BY sales-cost DESC) AS rank_per_month
FROM sale_cost_per_month_product
ORDER BY year,month)
SELECT 
year || '-' || month AS month_year,
product_id,
name AS product_name,
sales,
cost,
profit,
ranked_profit_per_month
FROM ranked_profit_per_month
WHERE rank_per_month <=5;
--5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
--Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
SELECT
DATE(created_at) AS dates,
category AS product_categories,
SUM(sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id = b.id
WHERE DATE(created_at) >= DATE_SUB('2022-04-15',INTERVAL 3 MONTH) -- DATE_SUB : tru di 1 khoan thoi gian ke tu ngay cu the dung trong bigquery va mysql
GROUP BY DATE(created_at),category
ORDER BY product_categories,dates
