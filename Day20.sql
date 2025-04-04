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

SELECT cohort_date,index,
COUNT(DISTINCT customerid) AS count_cus,
SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date,index
