/*Query to find the number of days between each user's first post of 
the year and last post of the year in the year 2021.
Chi xet nhung user co so bai post trong nam 2021 it nhat la 2.
output the user and number of the days between*/
SELECT user_id,
MAX(DATE(post_date))-MIN(DATE(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(*) >=2;
