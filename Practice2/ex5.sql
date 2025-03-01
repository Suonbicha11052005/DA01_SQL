/*Truy van danh sach candidateS dat yeu cau cua Data Science job
( tuc la co 3 skill: Python, Tableau, PostgreSQL). 
Sort by candidate_id
Khong co duplicates trong bang*/
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(*) = 3
ORDER BY candidate_id;
