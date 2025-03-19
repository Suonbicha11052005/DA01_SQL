/*Write a solution to find the people who have the most friends and the most friends number.*/
//Ham dem so ban cho user_ID
WITH friends_count AS(
    SELECT requester_id AS user_id,
    COUNT(accepter_id) AS friend_count
    FROM RequestAccepted
    GROUP BY requester_id
    UNION ALL
    SELECT accepter_id AS user_id,
    COUNT(requester_id) AS friend_count
    FROM RequestAccepted
    GROUP BY accepter_id
)
SELECT user_id AS id,
SUM(friend_count) AS num
FROM friends_count
GROUP BY user_id
ORDER BY num DESC
LIMIT 1
