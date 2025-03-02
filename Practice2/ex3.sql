/*Write a query calculating the amount of error (i.e.:  average monthly salaries), actual - miscalculated (gia tri thuc - gia tri do loi so 0)
and round it up to the next integer.*/
SELECT CEIL(AVG(Salary)-AVG(REPLACE(Salary,'0','')))
FROM EMPLOYEES
