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
