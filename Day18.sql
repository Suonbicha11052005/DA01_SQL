--C1: Su dung IQR de tim ra outlier
--B1: Tim Q1,Q3,IQR
--B2: Tim min=Q1-1.5*IQR, max=Q3+1.5*IQR
--B3: Xac dinh outlier<min, >max
WITH twt_min_max AS(
SELECT Q1-1.5*IQR AS min,
Q3+1.5*IQR AS max
FROM(
SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY users) AS Q1,
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY users) AS Q3,
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY users)-PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY users) AS IQR
FROM user_data
) AS a)
SELECT * FROM user_data
WHERE users<(SELECT min FROM twt_min_max) OR users>(SELECT max FROM twt_min_max)
--C2: Su dung diem Z-score=(z-avg)/do lech chuan
WITH cte AS(
SELECT *,
(SELECT AVG(users)
FROM user_data) AS avg,
(SELECT stddev(users)
FROM user_data) AS stddev
FROM user_data),
twt_outlier AS(
SELECT data_date,users,
(users-avg)/stddev AS z_score
FROM cte
WHERE abs((users-avg)/stddev)>3)
--Xu ly outlier
--C1: Thay the
UPDATE user_data
SET users=(SELECT avg(users) FROM user_data)
WHERE users IN(SELECT users FROM twt_outlier)
--C2: loai bo
DELETE FROM user_data
WHERE users IN(SELECT users FROM twt_outlier)
