/*Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.*/
SELECT name AS results FROM(
    SELECT b.name,COUNT(a.movie_id) AS rate_count
    FROM MovieRating AS a
    JOIN Users AS b
    ON a.user_id=b.user_id
    GROUP BY b.name
    ORDER BY COUNT(a.movie_id) DESC,b.name ASC
    LIMIT 1
)
UNION ALL
SELECT title AS results FROM(
    SELECT d.title,AVG(c.rating) AS avg_rate
    FROM MovieRating AS c
    JOIN Movies AS d
    ON c.movie_id=d.movie_id
    WHERE EXTRACT(MONTH FROM c.created_at)=2 AND EXTRACT(YEAR FROM c.created_at)=2020
    GROUP BY d.title
    ORDER BY avg_rate DESC,d.title ASC
    LIMIT 1
)
