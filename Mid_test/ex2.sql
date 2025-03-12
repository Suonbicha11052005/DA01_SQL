/*Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau

low: 9.99 - 19.99

medium: 20.00 - 24.99

high: 25.00 - 29.99*/
SELECT 
CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20 AND 24.99 THEN 'medium'
	WHEN replacement_cost BETWEEN 25 AND 29.99 THEN 'high'
END AS category,
COUNT(*) so_luong_film
FROM film
GROUP BY category
