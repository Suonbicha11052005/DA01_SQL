/*Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
Dung CTE ket hop voi JOIN*/
WITH first_year_products
AS(
    SELECT product_id,MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
)
SELECT a.product_id,a.year AS first_year,a.quantity,a.price
FROM Sales AS a
JOIN first_year_products AS b
ON a.product_id=b.product_id AND a.year=b.first_year
/*Cach nay dung subqueries nhung ma ton thoi gian hon, lau
SELECT a.product_id,
a.year AS first_year,
a.quantity,
a.price
FROM Sales AS a
WHERE a.year = (SELECT MIN(b.year) 
FROM Sales AS b
WHERE a.product_id=b.product_id)*/
