/*Write a query to return the IDs of the Facebook pages that have 
zero likes. The output should be sorted in ascending order based 
on the page IDs.(page_likes.page_id IS NULL neu left join)*/
SELECT t1.page_id
FROM pages AS t1
LEFT JOIN page_likes AS t2
ON t1.page_id=t2.page_id
WHERE t2.page_id IS NULL
ORDER BY t1.page_id
