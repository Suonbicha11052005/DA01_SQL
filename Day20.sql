/*B1: Khám phá và làm sạch dữ liệu
- Chúng ta đang quan tâm đến trường nào
- Check null
- Chuyển đổi kiểu dữ liệu
- Số tiền và số lượng > 0
- Check duplicate*/
-- Có 541909 bản ghi
-- Có 135080 bản ghi có customerid null
WITH online_retail_convert AS (
SELECT
invoiceno,
stockcode,
description,
CAST(quantity AS int) AS quantity,
TO_TIMESTAMP(invoicedate,'MM-DD-YYYY HH24:MI:SS') AS invoicedate,
CAST(unitprice AS numeric) AS unitprice,
customerid,
country
FROM online_retail
WHERE customerid <>'' AND CAST(quantity AS int)>0 AND CAST(unitprice AS numeric)>0)
,online_retail_main AS(
SELECT * FROM(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY invoiceno,stockcode,quantity ORDER BY invoicedate ) AS stt
FROM online_retail_convert
) AS a
WHERE stt = 1)
/*B2: 
- Tìm ngày mua hàng đầu tiên của mỗi khách hàng -> cohort date
- Tìm index =tháng (ngày mua hàng - ngày đầu tiên) + 1
- Count số lượng kh hoặc tổng doanh thu tại mỗi cohort_date và index tương ứng
*/
,online_retail_index AS(
SELECT customerid,amount,
TO_CHAR(first_purchase_date,'yyyy-mm') AS cohort_date,
(EXTRACT(YEAR FROM invoicedate)-EXTRACT(YEAR FROM first_purchase_date))*12+EXTRACT(MONTH FROM invoicedate)-EXTRACT(MONTH FROM first_purchase_date)+1 AS index
FROM(SELECT 
customerid,
unitprice*quantity AS amount,
invoicedate,
MIN(invoicedate) OVER (PARTITION BY customerid) AS first_purchase_date
FROM online_retail_main) a)
,xxx AS(
SELECT cohort_date,index,
COUNT(DISTINCT customerid) AS count_cus,
SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date,index)

--B3: Pivot Table -> Cohort Chart
-- Customer_cohort
,customer_cohort AS(
SELECT
cohort_date,
SUM(CASE WHEN index = 1 THEN count_cus ELSE 0 END) AS m1,
SUM(CASE WHEN index = 2 THEN count_cus ELSE 0 END) AS m2,
SUM(CASE WHEN index = 3 THEN count_cus ELSE 0 END) AS m3,
SUM(CASE WHEN index = 4 THEN count_cus ELSE 0 END) AS m4,
SUM(CASE WHEN index = 5 THEN count_cus ELSE 0 END) AS m5,
SUM(CASE WHEN index = 6 THEN count_cus ELSE 0 END) AS m6,
SUM(CASE WHEN index = 7 THEN count_cus ELSE 0 END) AS m7,
SUM(CASE WHEN index = 8 THEN count_cus ELSE 0 END) AS m8,
SUM(CASE WHEN index = 9 THEN count_cus ELSE 0 END) AS m9,
SUM(CASE WHEN index = 10 THEN count_cus ELSE 0 END) AS m10,
SUM(CASE WHEN index = 11 THEN count_cus ELSE 0 END) AS m11,
SUM(CASE WHEN index = 12 THEN count_cus ELSE 0 END) AS m12,
SUM(CASE WHEN index = 13 THEN count_cus ELSE 0 END) AS m13
FROM xxx
GROUP BY cohort_date)
--Retention cohort
SELECT
cohort_date,
ROUND(m1*100.0/m1,2) || '%' AS m1,
ROUND(m2*100.0/m1,2) || '%' AS m2,
ROUND(m3*100.0/m1,2) || '%' AS m3,
ROUND(m4*100.0/m1,2) || '%' AS m4,
ROUND(m5*100.0/m1,2) || '%' AS m5,
ROUND(m6*100.0/m1,2) || '%' AS m6,
ROUND(m7*100.0/m1,2) || '%' AS m7,
ROUND(m8*100.0/m1,2) || '%' AS m8,
ROUND(m9*100.0/m1,2) || '%' AS m9,
ROUND(m10*100.0/m1,2) || '%' AS m10,
ROUND(m11*100.0/m1,2) || '%' AS m11,
ROUND(m12*100.0/m1,2) || '%' AS m12,
ROUND(m13*100.0/m1,2) || '%' AS m13
FROM customer_cohort
--churn cohort (ty le roi bo = 100 - round())
