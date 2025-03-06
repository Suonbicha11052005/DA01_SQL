--INNER JOIN
--Ket noi 2 bang table 1 va table 2 bang INNER JOIN
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
