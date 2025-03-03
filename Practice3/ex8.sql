/*You have been asked to find the number of employees hired between the months of January and July in the year 2022 inclusive.*/
select COUNT(*) AS  number_employee
from employees
WHERE EXTRACT(year FROM joining_date) = 2022 
AND EXTRACT(month FROM joining_date) BETWEEN 1 AND 7;
