/*Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month
is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued
amount.*/
--C1: WINDOW FUNCTION WITH ROW_NUMBER(khong the dung FIRST_VALUE vi no chi lay gia tri dau tien cua COT DO R CHO CAC DONG KIA )
WITH twt_main_amount AS(
SELECT card_name,issue_year,issue_month,
SUM(issued_amount) AS amount
FROM monthly_cards_issued
GROUP BY card_name,issue_year,issue_month
),
ranked_cards AS(
SELECT card_name,issue_year,issue_month,amount,
ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) AS rank
FROM twt_main_amount
)
SELECT card_name,amount AS issue_amount
FROM ranked_cards
WHERE rank = 1
ORDER BY amount DESC
--C2: SUBQUERIES CTES
WITH twt_main_amount AS (
    SELECT 
        card_name,
        issue_year,
        issue_month,
        SUM(issued_amount) AS amount
    FROM monthly_cards_issued
    GROUP BY card_name, issue_year, issue_month
)
SELECT card_name, amount AS issued_amount
FROM twt_main_amount AS t1
WHERE (issue_year, issue_month) = (
    SELECT MIN(issue_year), MIN(issue_month) 
    FROM twt_main_amount AS t2 
    WHERE t1.card_name = t2.card_name
)
ORDER BY issued_amount DESC;
