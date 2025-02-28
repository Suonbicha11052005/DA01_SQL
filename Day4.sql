--GROUP BY
--Hay cho bk moi khach hang da tra bao nhieu tien
SELECT customer_id,
SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id;
--Gom nhom 2 truong
SELECT customer_id,staff_id,
SUM(amount) AS total_amount,
MIN(amount) AS min_amount
FROM payment
group BY customer_id,staff_id
ORDER BY customer_id;
--Toi da, toi tieu,trung binh, tong chi phi thay the theo tung bo film
SELECT film_id,
MAX(replacement_cost) AS max_cost,
MIN(replacement_cost) AS min_cost,
ROUND(AVG(replacement_cost),2) AS avg_cost,
SUM(replacement_cost) AS sum_cost
FROM film
GROUP BY film_id
ORDER BY film_id;
--HAVING
--Hay cho bk khach hang nao da tra tong so tien >100$ trong thang 1
SELECT customer_id,
SUM(amount) AS total_amount
FROM payment
WHERE payment_date BETWEEN '2020-01-01' AND '2020-02-01'
GROUP BY customer_id
HAVING sum(amount) > 100
--HAVING CHALLENGE
--So tien thanh toan trung binh duoc nhom theo khach hang va ngay thanh toan trong ngay 28,29,30/4
--Chi xem xet nhung ngay ma khach hang co nhieu hon 1 khoan thanh toan
--Sap xep theo so tien trung binh giam dan
SELECT customer_id,DATE(payment_date),
ROUND(AVG(amount),2) AS avg_amount
FROM payment
WHERE payment_date BETWEEN '2020-04-28' AND '2020-05-01'
--WHERE DATE(payment_date) IN ('2020-04-28','2020-04-29','2020-04-30')
GROUP BY customer_id,DATE(payment_date)
HAVING COUNT(payment_id) > 1 -- COUNT(*)
ORDER BY AVG(amount) DESC;
--TOAN TU VA HAM SO HOC
SELECT film_id,rental_rate
rental_rate+1 AS new_rental_rate
FROM film;
--TOAN TU VA HAM SO HOC CHALLENGE
/*Tao danh sach cac bo phim co gia thue it hon 4% chi phi thay the
Tao danh sach film_id cung voi ty le phan tram (gia thue/chi phi thay the) duoc lam tron den 2 chu so thap phan*/
SELECT film_id,rental_rate,replacement_cost,
ROUND((rental_rate/replacement_cost)*100,2) AS ty_le_phan_tram
FROM film
WHERE ROUND((rental_rate/replacement_cost)*100,2) < 4
