/*Tạo danh sách trả ra 2 cột dữ liệu:

-          cột 1: thông tin thành phố và đất nước ( format: “city, country")

-          cột 2: doanh thu tương ứng với cột 1*/
SELECT t1.city || ', ' || t5.country AS city_country,
SUM(t4.amount) AS amount
FROM city AS t1
JOIN address AS t2 ON t1.city_id=t2.city_id
JOIN customer AS t3 ON t2.address_id=t3.address_id
JOIN payment AS t4 ON t3.customer_id=t4.customer_id
JOIN country AS t5 ON t1.country_id=t5.country_id
GROUP BY t1.city,t5.country
ORDER BY amount
