/*For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id*/
SELECT mng.employee_id,mng.name,COUNT(*) AS reports_count,
ROUND(AVG(emp.age),0) AS average_age
FROM Employees AS emp
JOIN Employees AS mng
ON emp.reports_to=mng.employee_id
GROUP BY mng.employee_id
ORDER BY mng.employee_id
