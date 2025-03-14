/*Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id 
column.*/
WITH calls_of_holders
AS(
SELECT policy_holder_id,COUNT(case_id) AS count_calls
FROM callers
GROUP BY policy_holder_id)
SELECT COUNT(DISTINCT policy_holder_id) AS policy_holder_count
FROM calls_of_holders
WHERE count_calls >= 3
--Co the dung subqueries in from
SELECT COUNT(DISTINCT policy_holder_id) AS policy_holder_count
FROM (SELECT policy_holder_id,COUNT(case_id) AS count_calls
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3) calls_of_holders
  
