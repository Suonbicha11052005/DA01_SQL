--Hien thi khach hang co ma 322,346,354
--va co so tien <2 hoac lon hon 10
--Danh sach phai sap xep theo thu tu tang dan cua ma khach hang va giam dan theo so tien
SELECT * FROM payment
WHERE (customer_id=322 OR customer_id=346 OR customer_id=354) AND (amount<2 OR amount>10)
ORDER BY customer_id,amount DESC;
--6 khach hang co ma 12,25,67,93,124,234
--voi so tien 4.99,7.99,9.99
--trong thang 1 nam 2020
SELECT * FROM payment
WHERE customer_id IN (12,25,67,93,124,234)
AND amount IN (4.99,7.99,9.99)
AND payment_date BETWEEN '2020-01-01' AND '2020-02-01';
--tim cac khach hang co last name bat dau bang J hoac S
SELECT * FROM customer
WHERE last_name LIKE 'J%' OR last_name LIKE 'S%';
--tim cac khach hang co last name khong bat dau bang J hoac S
SELECT * FROM customer
WHERE last_name NOT LIKE 'J%' AND last_name NOT LIKE 'S%';
--Danh sach cac bo phim co chua Saga trong phan mo ta va tieu de bat dau bang A hoac ket thuc bang R
SELECT film_id,title FROM film
WHERE description LIKE '%Saga%'
AND (title LIKE 'A%' OR title LIKE '%R');
--Danh sach cac khach hang co ten chua 'ER' va chu cai thu 2 la 'A'
--Sap xep theo ho giam dan
SELECT customer_id,first_name FROM customer
WHERE first_name LIKE '%ER%' AND first_name LIKE '_A%'
ORDER BY last_name DESC;
