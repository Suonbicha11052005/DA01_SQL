/*Write a query to identify the top 2 Power Users who sent the 
highest number of messages on Microsoft Teams in August 2022. Display 
the IDs of these 2 users along with the total number of messages they 
sent. Output the results in descending order based on the count of 
the messages.*/
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-09-01'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;
