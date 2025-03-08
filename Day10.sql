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

