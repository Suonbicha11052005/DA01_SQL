--LOWER-UPPER-LENGTH CHALLENGE
--Liet ke cac khach hang co ho hoac ten co nhieu hon 10 ki tu. Xuat ra dang chu thuong
SELECT LOWER(first_name) AS lower_first_name,
LOWER(last_name) AS lower_last_name
FROM customer
WHERE LENGTH(last_name)>10 OR LENGTH(first_name)>10;
--LEFT-RIGHT CHALLENGE
--Trich xuat 5 ki tu cuoi cung cua dia chi email
--Bk dia chi email luon ket thuc '.org'
--Trich xuat dau cham tu dia chi email
SELECT RIGHT(email,5) AS five_char_right,
LEFT(RIGHT(email,4),1) AS char
FROM customer;
--NOI CHUOI CHALLENGE
--De bao mat du lieu, yeu cau hay mask dia chi email nhu sau:
--MARRY.SMITH@sakilacustomer.org -> MAR***H@sakilacustomer.org
SELECT email,
LEFT(email,3) || '***' || RIGHT(email,20) 
FROM customer;
--SUBSTRING CHALLENGE
--Trich xuat ten tu dia chi email sau do noi voi ho theo dang "Ho, ten" cho trc email, ho
SELECT email,last_name,
SUBSTRING(email FROM 1 FOR POSITION('.'IN email)-1) AS first_name,
CONCAT(last_name,', ',SUBSTRING(email FROM 1 FOR POSITION('.'IN email)-1)) AS name
FROM customer;
--EXTRACT
--Nam 2020, co bn don hang cho thue trong moi thang
SELECT EXTRACT(month FROM rental_date),
COUNT(*)
FROM rental
WHERE EXTRACT(year FROM rental_date) = '2020'
GROUP BY EXTRACT(month FROM rental_date);
--EXTRACT CHALLENGE
--Thang nao co tong so tien thanh toan cao nhat
--Ngay nao trong tuan co tong so tien thanh toan cao nhat.(0 la chu nhat)
--So tien cao nhat ma 1 khach hang da chi tieu trong hang tuan
SELECT EXTRACT( month FROM payment_date) AS month_of_year,
SUM(amount) AS total_amount
FROM payment
GROUP BY EXTRACT(month FROM payment_date)
ORDER BY total_amount_of_month DESC;
SELECT EXTRACT( DOW FROM payment_date) AS day_of_week,
SUM(amount) AS total_amount
FROM payment
GROUP BY EXTRACT(DOW FROM payment_date)
ORDER BY total_amount DESC;
SELECT customer_id,
EXTRACT(week FROM payment_date),
SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id,EXTRACT(week FROM payment_date)
ORDER BY SUM(amount) DESC
--INTERVAL CHALENGE
--Tao danh sach tat ca thoi gian thue cua khach hang voi customer_id = 35
--Khach hang nao co thoi gian thue trung binh dai nhat
SELECT customer_id,rental_date,return_date,
return_date - rental_date
FROM rental
WHERE customer_id = 35;
SELECT customer_id,
AVG(return_date-rental_date) AS avg_time 
FROM rental
GROUP BY customer_id
ORDER BY avg_time DESC;
/*c2:
SELECT customer_id,
AVG(24*EXTRACT(day FROM return_date-rental_date)+ EXTRACT(hour FROM return_date-rental_date) ) || ' h' AS avg_time 
FROM rental
GROUP BY customer_id
ORDER BY avg_time DESC*/
