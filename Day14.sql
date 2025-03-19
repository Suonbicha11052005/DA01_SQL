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

/*Truy van tra ve tat ca chi tiet thanh toan bao gom so lan thuc hien thanh toan boi khach hang nay va so
tien do. Sap xep ket qua theo payment_id*/
