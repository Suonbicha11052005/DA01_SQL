/*Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.*/
SELECT t1.product_name,SUM(t2.unit) AS unit
FROM Products AS t1
JOIN Orders AS t2
ON t1.product_id=t2.product_id
WHERE EXTRACT(month FROM t2.order_date)=2 AND EXTRACT(year FROM t2.order_date)=2020
GROUP BY t1.product_name
HAVING SUM(t2.unit)>=100
