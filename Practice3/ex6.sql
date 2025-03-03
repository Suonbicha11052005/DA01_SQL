/*Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
Viết giải pháp để tìm ID của các tweet không hợp lệ. Tweet không hợp lệ nếu số ký tự được sử dụng trong nội dung của tweet lớn hơn 15*/
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15
