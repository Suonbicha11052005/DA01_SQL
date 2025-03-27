--1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN ordernumber TYPE INT USING ordernumber::integer,
ALTER COLUMN quantityordered TYPE INT USING quantityordered::integer,
ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric,
ALTER COLUMN orderlinenumber TYPE INT USING orderlinenumber::integer,
ALTER COLUMN sales TYPE numeric USING sales::numeric,
ALTER COLUMN orderdate TYPE TIMESTAMP USING TO_TIMESTAMP(orderdate,'MM/DD/YYYY HH24:MI'),
ALTER COLUMN msrp TYPE INT USING msrp::integer;
--2. Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT * FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered IS NULL
OR priceeach IS NULL
OR orderlinenumber IS NULL
OR sales IS NULL
OR orderdate IS NULL;
/*Trường hợp trước đây orderdate là kiểu VARCHAR và có thể chứa '' (chuỗi rỗng), khi chuyển sang TIMESTAMP, bạn cần thay thế giá trị '' thành NULL trước.
UPDATE sales_dataset_rfm_prj 
SET orderdate = NULL 
WHERE orderdate = '';
ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN orderdate TYPE TIMESTAMP 
USING TO_TIMESTAMP(orderdate, 'MM/DD/YYYY HH24:MI');
*/
--3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR,
ADD COLUMN CONTACTFIRSTNAME VARCHAR;
UPDATE sales_dataset_rfm_prj
SET CONTACTLASTNAME=UPPER(LEFT(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1),1))||LOWER(SUBSTRING(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1),2)),
	CONTACTFIRSTNAME=UPPER(LEFT(LEFT(contactfullname,POSITION('-' IN contactfullname)-1),1))||LOWER(SUBSTRING(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)-1),2));
--4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;
UPDATE sales_dataset_rfm_prj
SET qtr_id=EXTRACT(QUARTER FROM orderdate),
	month_id=EXTRACT(MONTH FROM orderdate),
	year_id=EXTRACT(YEAR FROM orderdate);
--5.
--Danh sach outlier se luu trong twt_outlier
WITH cte AS(
SELECT *,
(SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj) AS avg_quantityordered,
(SELECT stddev(quantityordered) FROM sales_dataset_rfm_prj) AS stddev_quantityordered
FROM sales_dataset_rfm_prj
),
twt_outlier AS(
SELECT *,
(quantityordered-avg_quantityordered)/stddev_quantityordered AS z_score
FROM cte
WHERE abs((quantityordered-avg_quantityordered)/stddev_quantityordered)>3
)
/*--Xu ly outlier
--C1:
UPDATE sales_dataset_rfm_prj
SET quantityordered=(SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj)
WHERE quantityordered IN(SELECT quantityordered FROM twt_outlier);
--C2:
DELETE FROM sales_dataset_rfm_prj
WHERE quantityordered IN(SELECT quantityordered FROM twt_outlier);*/
