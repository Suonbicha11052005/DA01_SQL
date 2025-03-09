--INNER JOIN
--Ket noi 2 bang table 1 va table 2 bang INNER JOIN ( lay cac key chung cua 2 bang)
--INNER JOIN giua 2 bang payment va customer
SELECT t2.payment_id,t2.customer_id,t1.first_name,t1.last_name
FROM customer AS t1
INNER JOIN payment AS t2
ON t1.customer_id=t2.customer_id
--Co bao nguoi chon ghe ngoi theo cac loai sau
--Bussiness
--Economy
--Comfort
SELECT t2.fare_conditions,COUNT(flight_id) AS count
FROM boarding_passes AS t1
INNER JOIN seats AS t2
ON t1.seat_no=t2.seat_no
GROUP BY t2.fare_conditions
--LEFT-RIGHT JOIN 
--Tim cac chuyen bay cua tung may  bay
SELECT t1.flight_no,t2.aircraft_code
FROM flights AS t1
RIGHT JOIN aircrafts_data AS t2
ON t1.aircraft_code=t2.aircraft_code
WHERE flight_no IS NULL;
/*SELECT t2.flight_no,t1.aircraft_code
FROM aircrafts_data AS t1
LEFT JOIN flights AS t2
ON t1.aircraft_code=t2.aircraft_code
WHERE flight_no IS NULL*/
--LEFT-RIGHT CHALLENGE
--Tim hieu ghe nao duoc dat thuong xuyen nhat(dam bao tat ca cac ghe duoc liet ke ngay ca khi chung ch dat bao h)
SELECT t1.seat_no,COUNT(ticket_no)
FROM seats AS t1
LEFT JOIN boarding_passes AS t2
ON t1.seat_no=t2.seat_no
GROUP BY t1.seat_no
ORDER BY COUNT(ticket_no) DESC
--Co cho ngoi nao chua bao h duoc dat hay k
SELECT t1.seat_no
FROM seats AS t1
LEFT JOIN boarding_passes AS t2
ON t1.seat_no=t2.seat_no
WHERE ticket_no IS NULL
--Chi ra hang ghe nao duoc dat thuong xuyen nhat
SELECT RIGHT(t1.seat_no,1) AS line,COUNT(flight_id)
FROM seats AS t1
LEFT JOIN boarding_passes AS t2
ON t1.seat_no=t2.seat_no
GROUP BY line
ORDER BY COUNT(flight_id) DESC
--FULL JOIN
--Dem co bn ve may bay ma k len duoc may bay
SELECT COUNT(*)
FROM boarding_passes AS t1
FULL JOIN tickets AS t2
ON t1.ticket_no=t2.ticket_no
WHERE t1.ticket_no IS NULL
--JOIN ON MULTIPLE CONDITIONS
--Tinh gia trung binh cua tung so ghe may bay
SELECT t1.seat_no,
AVG(t2.amount) AS avg_amount
FROM boarding_passes AS t1
LEFT JOIN ticket_flights AS t2
ON t1.ticket_no=t2.ticket_no AND t1.flight_id=t2.flight_id
GROUP BY t1.seat_no
ORDER BY avg_amount DESC
--JOIN MULTIPE TABLES CHALLENGE
--Truy van lay first_name,last_name, email va quoc gia cua tat ca cac khach hang
--Nhung khach hang nao den tu brazil
SELECT t4.first_name,t4.last_name,t4.email,t1.country
FROM country AS t1
INNER JOIN city AS t2 ON t1.country_id=t2.country_id
INNER JOIN address AS t3 ON t2.city_id=t3.city_id
INNER JOIN customer AS t4 ON t3.address_id=t4.address_id
WHERE t1.country='Brazil'
--SELF JOIN
--Hien thi thong tin cua tat ca nhan vien
SELECT emp.employee_id,emp.name AS emp_name,emp.manager_id,mng.name AS mng_name
FROM employee AS emp
LEFT JOIN employee AS mng
ON emp.manager_id=mng.employee_id
--SELF JOIN CHALLENGE
--Tim nhung bo phim co cung thoi luong phim key khong phai la khoa chinh
SELECT t1.title AS title1,t2.title AS title2,t1.length
FROM film AS t1
JOIN film AS t2 ON t1.length=t2.length
WHERE t1.title<>t2.title
--UNION
SELECT first_name,'actor' AS source FROM actor
UNION ALL
SELECT first_name,'customer' AS source FROM customer
UNION ALL
SELECT first_name,'staff' AS source FROM staff
ORDER BY first_name
