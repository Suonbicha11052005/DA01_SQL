--CASE-WHEN: Dùng để phân loại
--Hay phan loai cac bo phim theo thoi luong short-medium-long: short < 60ph, medium: 60-120, long: >120
SELECT film_id,
CASE
	WHEN length < 60 THEN 'short'
	WHEN length BETWEEN 60 AND 120 THEN 'medium'
	WHEN length > 120 THEN  'long'
	--ELSE 'long'
END category
FROM film;
--Dem moi loai co bao nhieu film
SELECT 
CASE
	WHEN length < 60 THEN 'short'
	WHEN length BETWEEN 60 AND 120 THEN 'medium'
	WHEN length > 120 THEN  'long'
	--ELSE 'long'
END category,
COUNT(*) AS so_luong_film
FROM film
GROUP BY category;
--Bo phim co tag la 1 neu truong rating la G hoac PG
--tag la 0 tat ca truong hop con lai
SELECT film_id,
CASE
	WHEN rating IN ('G','PG') THEN 1
	ELSE 0
END tag
FROM film;
--CASE - WHEN CHALLENGE
--Xem cong ty da ban bn nhieu ve trong cac danh muc sau
--Low price ticket: total_amount < 20000
--Mid price ticket: total_amount between 20000 and 150000
--High price ticket: total_amount > 150000
SELECT 
CASE
	WHEN amount <20000 THEN 'Lower price ticket'
	WHEN amount BETWEEN 20000 AND 150000 THEN 'Mid price ticket'
	ELSE 'High price ticket'
END category,
COUNT (*) AS so_luong_ve
FROM ticket_flights
GROUP BY category;
--Ban can biet co bao nhieu chuyen bay da khoi hanh vao cac mua sau
--Mua xuan thang 2,3,4
--Mua he 5,6,7
--Mua thu 8,9,10
--Mua dong 11,12,1
SELECT
CASE
	WHEN EXTRACT(month FROM scheduled_arrival) IN(2,3,4) THEN 'Mua xuan'
	WHEN EXTRACT(month FROM scheduled_arrival) IN(5,6,7) THEN 'Mua he'
	WHEN EXTRACT(month FROM scheduled_arrival) IN(8,9,10) THEN 'Mua thu'
	ELSE 'Mua dong'
END season,
COUNT(*) AS so_chuyen_bay
FROM flights
GROUP BY season;
/*Tao phim phan cap do theo cach sau
+ Xep hang la 'PG' hoac 'PG-13' hoac thoi luong hon 210 ph
'Great rating or long (tier 1)'
+ Mo ta chua 'Drama' va thoi luong hon 90ph: Long drama (tier 2)
+ Mo ta chua 'Drama' va thoi luong k qua 90ph: Shcity drama (tier 3)
+ Gia thue thap hon $1: Very cheap (teir 4)
Neu 1 bo phim co the thuoc nhieu danh muc thi chi dinh o cap cao hon
Lam cach nao de chi co the loc nhung phim xuat hien 1 trong 4 cap do nay*/
SELECT film_id,
CASE
	WHEN rating IN('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
	WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
	WHEN description LIKE '%Drama%' AND length <= 90 THEN 'Shcity drama (tier 3)'
	WHEN rental_rate < 1 THEN 'Very cheap (teir 4)'
END cap_do
FROM film
WHERE 
CASE
	WHEN rating IN('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
	WHEN description LIKE '%Drama%' AND length > 90 THEN 'Long drama (tier 2)'
	WHEN description LIKE '%Drama%' AND length <= 90 THEN 'Shcity drama (tier 3)'
	WHEN rental_rate < 1 THEN 'Very cheap (teir 4)'
END IS NOT NULL
--PIVOT TABLE
  /*Tinh tong so tien theo tung loai hoa don high-medium-low cua tung khach hang
hight: amount > 10
medium: 5<=amount<=10
low: amount<5
SELECT customer_id,
CASE
	WHEN amount>10 THEN 'high'
	WHEN amount BETWEEN 5 AND 10 THEN 'medium'
	ELSE 'low'
END category,
SUM(amount)
FROM payment
GROUP BY category,customer_id
ORDER BY customer_id*/
SELECT customer_id,
SUM(CASE
	WHEN amount>10 THEN amount
	ELSE 0
END) AS high,
SUM(CASE
	WHEN amount BETWEEN 5 AND 10 THEN amount
	ELSE 0
END) medium,
SUM(CASE
	WHEN amount<5 THEN amount
	ELSE 0
END) low
FROM payment
GROUP BY customer_id
ORDER BY customer_id
/* PIVOT - CHALLENGE
  Thong ke co bao nhieu bo phim duoc danh gia la R,PG,PG-13 o cac the loai phim long-medium-short
long: length>120
medium: 60<=length<=120
short: length<60*/
SELECT 
CASE
	WHEN length < 60 THEN 'short'
	WHEN length BETWEEN 60 AND 120 THEN 'medium'
	WHEN length > 120 THEN  'long'
END AS category,
COUNT(CASE
	WHEN rating = 'R' THEN 1
	ELSE 0
END) AS r,
COUNT(CASE
	WHEN rating = 'PG' THEN 1
	ELSE 0
END) AS pg,
COUNT(CASE
	WHEN rating = 'PG-13' THEN 1
	ELSE 0
END) AS pg_13
FROM film
GROUP BY category
