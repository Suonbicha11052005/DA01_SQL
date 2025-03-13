/*hãy viết truy vấn để xác định hai sản phẩm có doanh thu cao nhất 
trong mỗi danh mục vào năm 2022. Đầu ra phải bao gồm danh mục, sản 
phẩm và tổng chi tiêu.
Dau tien phai tinh tong total_spend cho tung loai san pham cua tung
category
Sau do phai sap xep giam dan trong tung nhom category va mk se dung
rank de phan hang cho cac san pham va luu vao CTE
Sau do cho phan hang nho hon hoac bang 2 thi t se lay dc top2
*/
WITH ranked_spending_cte
AS(
SELECT category,
product,
SUM(spend) AS total_spend,
RANK() OVER(
PARTITION BY category
ORDER BY SUM(spend) DESC
) AS ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)=2022
GROUP BY category,product)
SELECT category,product,total_spend
FROM ranked_spending_cte
WHERE ranking<=2
