/*Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display 
the top 5 artist names in ascending order, along with their song appearance ranking.
If two or more artists have the same number of song appearances, they should be assigned the same ranking, and the rank numbers 
should be continuous (i.e. 1, 2, 2, 3, 4, 5).*/
WITH twt_rank_appear_top10 AS(
SELECT a.artist_name AS artist_name,
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS artist_rank
FROM artists AS a
JOIN songs AS b ON a.artist_id=b.artist_id
JOIN global_song_rank AS c ON b.song_id=c.song_id
WHERE c.rank<=10
GROUP BY a.artist_name
)
SELECT * FROM twt_rank_appear_top10
WHERE artist_rank<=5
ORDER BY rank,artist_name
