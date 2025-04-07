--B1: Tinh gia tri R-F-M
WITH customer_rfm AS(
SELECT
	a.customer_id,
	CURRENT_DATE - MAX(order_date) AS R,
	COUNT(DISTINCT order_id) AS F,
	SUM(sales) AS M
FROM customer AS a
JOIN sales AS b
ON a.customer_id = b.customer_id
GROUP BY a.customer_id)
-- B2: Chia cac gia tri thanh cac khoang tren thang 1-5
,rfm_score AS(
SELECT
customer_id,
ntile(5) OVER(ORDER BY R DESC) AS R_score,
ntile(5) OVER(ORDER BY F ) AS F_score,
ntile(5) OVER(ORDER BY M ) AS M_score
FROM customer_rfm)
--B3: Phan nhom theo 125 to hop RFM
,rfm_final AS(
SELECT
customer_id,
CAST(R_score AS VARCHAR) || CAST(F_score AS VARCHAR) || CAST(M_score AS VARCHAR) AS rfm_score
FROM rfm_score)

SELECT 
segment,
COUNT(*) AS count_customer
FROM(
	SELECT
	a.customer_id,b.segment
	FROM rfm_final AS a
	JOIN segment_score AS b
	ON a.rfm_score = b.scores
) AS a
GROUP BY segment
ORDER BY count_customer
--B4: Truwjc quan hoas du lieu RFM
