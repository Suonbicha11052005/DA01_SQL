/*Viết giải pháp để tìm giá của tất cả các sản phẩm trên 2019-08-16. Giả sử giá của tất cả các sản phẩm trước khi có bất kỳ thay đổi nào là 10.

Trả về bảng kết quả theo bất kỳ thứ tự nào .*/
--Cach nay ngan hon dung subqueries
SELECT t1.product_id AS product_id,COALESCE(t2.price,10) AS price
FROM (SELECT DISTINCT product_id FROM Products) AS t1
LEFT JOIN (
    SELECT a.product_id AS product_id,a.new_price AS price
    FROM Products AS a
    WHERE change_date=(
        SELECT MAX(change_date)
        FROM Products
        WHERE change_date <= '2019-08-16' AND product_id=a.product_id
    )
) AS t2
ON t1.product_id=t2.product_id
--Giong cach tren nhung dung CTE dai hon
WITH table1 AS(
    SELECT DISTINCT product_id
    FROM Products
),
table2 AS(
    SELECT product_id,MAX(change_date) AS new_date
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
)
SELECT t1.product_id AS product_id,COALESCE(t2.price,10) AS price
FROM table1 AS t1
LEFT JOIN (SELECT a.product_id AS product_id,a.new_price AS price
FROM Products AS a
WHERE change_date=(
    SELECT new_date
    FROM table2
    WHERE product_id=a.product_id
)) AS t2
ON t1.product_id=t2.product_id
--Dung FIRST_VALUE de tim gia cua nhung sp thay doi vao 16/8/2019 va dung left join de lay them nhung sp k thay doi gia
WITH price_history AS (
    SELECT product_id, 
           new_price, 
           change_date,
           FIRST_VALUE(new_price) OVER (
               PARTITION BY product_id 
               ORDER BY change_date DESC
           ) AS latest_price
    FROM Products
    WHERE change_date <= '2019-08-16'
)
SELECT DISTINCT p.product_id, 
       COALESCE(ph.latest_price, 10) AS price
FROM (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN price_history ph ON p.product_id = ph.product_id;

