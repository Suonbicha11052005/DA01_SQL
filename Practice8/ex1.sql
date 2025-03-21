/*Nếu ngày giao hàng mong muốn của khách hàng trùng với ngày đặt hàng thì đơn hàng được gọi là immediate; nếu không, đơn hàng được gọi là scheduled.

Đơn hàng đầu tiên của khách hàng là đơn hàng có ngày đặt hàng sớm nhất mà khách hàng thực hiện. Đảm bảo rằng mỗi khách hàng chỉ có đúng một đơn hàng đầu tiên.

Viết giải pháp để tìm tỷ lệ đơn hàng ngay lập tức trong những đơn hàng đầu tiên của tất cả khách hàng, làm tròn đến 2 chữ số thập phân .*/
--C1: SUBQUERIES
WITH twt_first_order AS(
    SELECT customer_id,
    order_date,
    customer_pref_delivery_date
    FROM Delivery AS a
    WHERE order_date=(
        SELECT MIN(order_date) 
        FROM Delivery AS b
        WHERE a.customer_id=b.customer_id
    )
)
SELECT 
ROUND(100.0*SUM(
    CASE
        WHEN order_date=customer_pref_delivery_date THEN 1
        ELSE 0
    END)/COUNT(*),2) AS immediate_percentage
FROM twt_first_order
--C2: RANK()
ITH first_orders AS (
    SELECT 
        delivery_id,
        customer_id,
        order_date,
        customer_pref_delivery_date,
        RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rnk
    FROM Delivery
)
SELECT 
    ROUND(100.0 * SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) 
          / COUNT(*), 2) AS immediate_percentage
FROM first_orders
WHERE rnk = 1;

