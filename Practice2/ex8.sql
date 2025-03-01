/*Viết truy vấn để xác định các nhà sản xuất có liên quan đến các loại
thuốc dẫn đến tổn thất cho CVS Health và tính toán tổng số tổn thất 
phát sinh.
Ghi tên nhà sản xuất, số lượng thuốc bị thất thoát và tổng thất thoát
ở giá trị tuyệt đối. Hiển thị kết quả được sắp xếp theo thứ tự 
giảm dần với mức tổn thất cao nhất hiển thị ở trên cùng.*/
SELECT manufacturer,
COUNT(*) AS drug_count,
SUM(cogs-total_sales) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC;
