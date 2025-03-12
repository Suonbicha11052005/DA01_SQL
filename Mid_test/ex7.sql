/*Danh sách các thành phố và doanh thu tương ừng trên từng thành phố

Question: Thành phố nào đạt doanh thu cao nhất ?*/
SELECT t1.city,SUM(t4.amount) AS amount
FROM city AS t1
JOIN address AS t2 ON t1.city_id=t2.city_id
JOIN customer AS t3 ON t2.address_id=t3.address_id
JOIN payment AS t4 ON t3.customer_id=t4.customer_id
GROUP BY t1.city
ORDER BY amount DESC
