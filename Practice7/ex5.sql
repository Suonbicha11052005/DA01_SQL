/*Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the 
user ID, tweet date, and rolling averages rounded to 2 decimal places.
Notes:
A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a 
specified period of time.
In this case, we want to determine how the tweet count for each user changes over a 3-day period.*/
--C1: LAG() chu y gia tri NULL doi sang 0 va khong cong no trong avg
SELECT user_id,tweet_date,
ROUND((tweet_count+COALESCE(LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date),0)
+COALESCE(LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date),0))*1.0/
(1+
CASE WHEN LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) IS NULL THEN 0 ELSE 1 END+
CASE WHEN LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) IS NULL THEN 0 ELSE 1 END)
,2) AS rolling_avg_3d
FROM tweets;
--C2: AVG() WINDOW FUNCTION
--Lay dong thoa dieu kien ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
SELECT user_id,tweet_date,
ROUND(AVG(tweet_count) OVER(
    PARTITION BY user_id
    ORDER BY tweet_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ),2) AS rolling_avg_3d
FROM tweets
--C3: SELF-JOIN (KHONG KHUYEN KHICH)
SELECT a.user_id,a.tweet_date,
ROUND(AVG(b.tweet_count),2) AS rolling_avg_3d
FROM tweets AS a 
JOIN tweets AS b
ON a.user_id=b.user_id AND b.tweet_date BETWEEN a.tweet_date - INTERVAL '2 DAY' AND a.tweet_date
GROUP BY a.user_id,a.tweet_date
ORDER BY a.user_id,a.tweet_date
