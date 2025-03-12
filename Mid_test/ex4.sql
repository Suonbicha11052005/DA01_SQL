/*Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).

Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?*/
SELECT t3.name,
COUNT(t1.title)||' titles' AS so_luong_film
FROM film AS t1
JOIN film_category AS t2 ON t1.film_id=t2.film_id
JOIN category AS t3 ON t2.category_id=t3.category_id
GROUP BY t3.name
ORDER BY so_luong_film DESC
