--WINDOW FUNCTION WITH SUM(), AVG(),MIN(),MAX(),COUNT()
/*Tinh ti le so tien thanh toan tung ngay voi tong so tien da thanh toan cua moi khach hang
output: ma KH, ten KH, ngay thanh toan, so tien thanh toan tai ngay, tong so tien da thanh toan, ti le*/
--C1: SUBQUERIES
SELECT a.customer_id,b.first_name,a.payment_date,a.amount,
(SELECT SUM(c.amount) AS total_amount
FROM payment c
WHERE c.customer_id=a.customer_id
GROUP BY c.customer_id),
a.amount/(SELECT SUM(c.amount) AS total_amount
FROM payment c
WHERE c.customer_id=a.customer_id
GROUP BY c.customer_id) AS ty_le
FROM payment AS a
JOIN customer AS b ON a.customer_id=b.customer_id;
--C2: CTE
WITH twt_total_payment AS(
	SELECT customer_id, SUM(amount) total_payment
	FROM payment
	GROUP BY customer_id
)
SELECT a.customer_id,b.first_name,a.payment_date,a.amount,c.total_payment,
a.amount/c.total_payment AS ty_le
FROM payment AS a 
JOIN twt_total_payment AS c ON a.customer_id=c.customer_id
JOIN customer AS  b ON a.customer_id=b.customer_id
--C3: WINDOW FUNCTION
SELECT a.customer_id,b.first_name,a.payment_date,a.amount,
SUM(a.amount) OVER(PARTITION BY a.customer_id) AS total_payment,
FROM payment AS a
JOIN customer AS b ON a.customer_id=b.customer_id
--WINDOW FUNCTION WITH SUM(),... CHALLENGE
/*Truy van tra ve danh sach phim bao gom: film_id, title, length, category, thoi luong trung binh cua film
trong category do. Sap xep ket qua theo film_id*/
SELECT a.film_id,a.title,a.length,c.name AS category,
AVG(a.length) OVER(PARTITION BY c.name) AS avg_length
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
ORDER BY a.film_id
/*Truy van tra ve tat ca chi tiet thanh toan bao gom so lan thuc hien thanh toan boi khach hang nay va so
tien do. Sap xep ket qua theo payment_id*/
SELECT *,
COUNT(payment_id) OVER(PARTITION BY customer_id,amount) AS so_lan
FROM payment
ORDER BY payment_id
--OVER() WITH ORDER BY: Cong nhung du lieu truoc day
SELECT payment_date,amount,
SUM(amount) OVER(ORDER BY payment_date) AS total_amount
FROM payment;
SELECT payment_date,customer_id,amount,
SUM(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS total_amount
FROM payment
--WINDOW FUNCTION WITH RANK()
--Xep hang do dai film cho tung the loai
--output: film_id,category, length, xep hang do dai film trong tung category
SELECT a.film_id,c.name AS category,a.length,
RANK() OVER(PARTITION BY c.name ORDER BY a.length DESC) AS rank1,
DENSE_RANK() OVER(PARTITION BY c.name ORDER BY a.length DESC) AS rank2,
ROW_NUMBER() OVER(PARTITION BY c.name ORDER BY a.length DESC,a.film_id ) AS rank3
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
--WINDOW FUNCTION WITH RANK() CHALLENGE
/*Viet truy van tra ve ten khach hang, quoc gia va so luong thanh toan ma ho co.
Tao bang xep hang nhung khach hang co doanh thu cao nhat cho moi quoc gia.
Loc ket qua chi 3 kkhach hang cao nhat cua moi quoc gia*/
SELECT * FROM(
SELECT a.first_name || ' ' || a.last_name AS full_name,
d.country,
COUNT(*) AS so_luong,
SUM(e.amount) AS amount,
RANK() OVER(PARTITION BY d.country ORDER BY SUM(e.amount) DESC) AS rank 
FROM customer AS a
JOIN address AS b ON a.address_id=b.address_id
JOIN city AS c ON b.city_id=c.city_id
JOIN country AS d ON c.country_id=d.country_id
JOIN payment AS e ON a.customer_id=e.customer_id
GROUP BY a.first_name || ' ' || a.last_name,d.country) AS f
WHERE f.rank<=3
