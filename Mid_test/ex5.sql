/*Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.

Question: Diễn viên nào đóng nhiều phim nhất?

Answer: Susan Davis : 54 movies

*/
SELECT t1.first_name,t1.last_name,COUNT(t2.film_id) AS so_luong_film
FROM actor AS t1
JOIN film_actor AS t2
ON t1.actor_id=t2.actor_id
GROUP BY t1.actor_id
ORDER BY so_luong_film DESC
