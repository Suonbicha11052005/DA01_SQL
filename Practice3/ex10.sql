/*Find the vintage years of all wines from the country of Macedonia. The year can be found in the 'title' column. Output the wine (i.e., the 'title') along with the year. The year should be a numeric or int data type.*/
select 
CAST(SUBSTRING(title FROM LENGTH(winery)+2 FOR 4) AS INTEGER) AS year
from winemag_p2
WHERE country = 'Macedonia'
