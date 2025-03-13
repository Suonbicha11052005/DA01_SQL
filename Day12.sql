--SUBQUERIES IN WHERE
--Tim nhung hoa don co so tien lon hon so tien trung binh cac hoa don
SELECT * FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment)
--Tim nhung hoa don cua khach hang co ten Adam
SELECT *
FROM payment AS t1
JOIN customer AS t2
ON t1.customer_id=t2.customer_id
WHERE t2.first_name = 'ADAM';
SELECT * FROM payment
WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name='ADAM')
--SUBQUERIES IN WHERE CHALLENGE
--Tim nhung bo phim co thoi luong lon hon trung binh cac bo phim
SELECT * FROM film
WHERE length > (SELECT AVG(length) FROM film)
--Tim nhung bo phim co o store 2 it nhat 3 lan
SELECT film_id,title
FROM film
WHERE film_id IN(SELECT film_id FROM inventory
WHERE store_id=2
GROUP BY film_id
HAVING COUNT(*) >= 3)
--Tim nhung khach hang da chi tieu nhieu hon 100
SELECT customer_id,first_name,last_name,email FROM customer
WHERE customer_id IN (SELECT customer_id FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100)
--SUBQUERIES IN FROM
--Tim nhung khach hang co nhieu hon 30 hoa don
--Dung HAVING CX DUOC
SELECT customer.first_name,new_table.so_luong FROM
(SELECT customer_id,
COUNT(*) AS so_luong
FROM payment
GROUP BY customer_id) AS new_table
JOIN customer ON new_table.customer_id=customer.customer_id
WHERE so_luong > 30
--SUBQUERIES IN SELECT
--Tim chenh lech so tien giua tung hoa don so voi so tien thanh toan lon nhat
SELECT payment_id,amount,
(SELECT MAX(amount) FROM payment) AS max_amount,
(SELECT MAX(amount) FROM payment) - amount AS chenh_lech
FROM payment
--CORRELATED SUBQUERIES IN WHERE
--Lay ra thong tin khach hang tu bang customer co tong hoa don >100$
--c1: JOIN GROUP BY HAVING
--c2: Subqueries in where
SELECT * FROM customer AS a
WHERE EXISTS (SELECT customer_id
FROM payment AS b
WHERE a.customer_id=b.customer_id
GROUP BY customer_id
HAVING SUM(amount)>100
)
--CORRELATED SUBQUERIES IN SELECT
--ma KH, ten KH, ma thanh toan, so tien lon nhat cua tung khach hang

SELECT a.customer_id,
a.first_name||a.last_name AS name,
b.payment_id,
(SELECT MAX(amount) as max_amount
FROM payment
WHERE customer_id=a.customer_id
GROUP BY customer_id)
FROM customer AS a
JOIN payment AS b
ON a.customer_id=b.customer_id
GROUP BY a.customer_id,
a.first_name||a.last_name,
b.payment_id
--CORRELATED SUBQUERIES IN SELECT CHALLENGE
--Liet ke cac khoan thanh toan voi tong so hoa don va tong so tien moi khach phai tra
SELECT t1.*,t2.count_payments,t2.sumt_amount
FROM payment AS t1
JOIN 
(SELECT customer_id,
COUNT(payment_id) AS count_payments,
SUM(amount) AS sumt_amount
FROM payment
GROUP BY customer_id) AS t2
ON t1.customer_id=t2.customer_id
  
SELECT a.*,
(SELECT COUNT(payment_id)
FROM payment AS b
WHERE b.customer_id=a.customer_id
GROUP BY customer_id) AS count_payments,
(SELECT SUM(amount)
FROM payment AS b
WHERE b.customer_id=a.customer_id
GROUP BY customer_id) AS sum_amount
FROM payment AS a
--Lay danh sach cac film co chi phi thay the lon nhat trong moi loai rating
--Ngoai film_id,title,rating, chi phi thay the, can hien thi them chi phi trung binh moi loai rating do

SELECT a.film_id,a.title,a.rating,a.replacement_cost,
(SELECT AVG(replacement_cost) FROM film AS b
WHERE b.rating=a.rating
GROUP BY rating) AS avg_rating
FROM film AS a
WHERE a.replacement_cost = (SELECT MAX(replacement_cost)
FROM film AS c
WHERE a.rating=c.rating
GROUP BY rating)
--CTEs
--Tim khach hang co nhieu hon 30 hoa don, ket qua tra ra gom cac thong tin: ma KH, ten KH, so luong hoa don,
--tong so tien,thoi gian thue trung binh
WITH twt_total_payment 
AS(
SELECT customer_id,
COUNT(*) as count_payments,
SUM(amount) sum_amount
FROM payment
GROUP BY customer_id),
twt_avg_rental_time
AS(
SELECT customer_id,
AVG(return_date-rental_date) AS rental_time
FROM rental
GROUP BY customer_id
)
SELECT a.customer_id,a.first_name,b.count_payments,b.sum_amount,c.rental_time
FROM customer AS a
JOIN twt_total_payment AS b ON a.customer_id=b.customer_id
JOIN twt_avg_rental_time AS c ON a.customer_id=c.customer_id
WHERE b.count_payments>30
--Tim nhung hoa don co so tien cao hon so tien trung binh cua khach hang do chi tieu tren moi hoa don
--ket qua tra ra:ma KH, ten KH, so luong hoa don, so tien, so tien trung binh cua khach hang do
WITH twt_avg
AS(
SELECT customer_id,
AVG(amount) AS avg_amount
FROM payment
GROUP BY customer_id
),
twt_count
AS(
SELECT customer_id,
COUNT(payment_id) AS count_payments
FROM payment
GROUP BY customer_id
)
SELECT a.customer_id,a.first_name,c.count_payments,b.amount,d.avg_amount
FROM customer AS a
JOIN payment AS b ON a.customer_id=b.customer_id
JOIN twt_count AS c ON a.customer_id=c.customer_id
JOIN twt_avg AS d ON a.customer_id=d.customer_id
WHERE b.amount > d.avg_amount
