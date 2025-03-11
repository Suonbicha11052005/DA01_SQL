/*A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product 
category listed in the products table.
Write a query that identifies the customer IDs of these Supercloud customers.*/
SELECT t1.customer_id
FROM customer_contracts AS t1
INNER JOIN products AS t2
ON t1.product_id=t2.product_id
GROUP BY t1.customer_id
HAVING COUNT(DISTINCT t2.product_category)=(SELECT COUNT(DISTINCT product_category) FROM products)
