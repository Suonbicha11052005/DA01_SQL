/*Make a report showing the number of survivors and non-survivors by passenger class. Classes are categorized based on the 
pclass value as:
•	First class: pclass = 1
•	Second class: pclass = 2
•	Third class: pclass = 3
Output the number of survivors and non-survivors by each class.*/
/*select
CASE
    WHEN pclass=1 THEN 'First class'
    WHEN pclass=2 THEN 'Second class'
    ELSE 'Third class'
END AS class,
SUM(CASE
    WHEN survived = 1 THEN 1
    ELSE 0
END) AS survivors,
SUM(CASE
    WHEN survived = 0 THEN 1
    ELSE 0
END) AS non_survivors
from titanic
GROUP BY class 3 cot la class,survived,non_survived*/
select
survived,
SUM(CASE
    WHEN pclass=1 THEN 1
    ELSE 0
END) AS first_class,
SUM(CASE
    WHEN pclass=2 THEN 1
    ELSE 0
END) AS second_class,
SUM(CASE
    WHEN pclass=3 THEN 1
    ELSE 0
END) AS third_class
from titanic
GROUP BY survived
