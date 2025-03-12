/*Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) được sắp xếp 
theo độ dài giảm dần. Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.*/
SELECT t1.title,t1.length,t3.name
FROM film AS t1
JOIN film_category AS t2 ON t1.film_id=t2.film_id
JOIN category AS t3 ON t2.category_id=t3.category_id
WHERE t3.name IN('Drama','Sports')
ORDER BY t1.length DESC
