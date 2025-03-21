/*Viết giải pháp để báo cáo phân số người chơi đã đăng nhập lại vào ngày sau ngày họ đăng nhập lần đầu, làm tròn đến 2 chữ số thập phân . Nói cách khác, bạn cần đếm số người 
chơi đã đăng nhập trong ít nhất hai ngày liên tiếp bắt đầu từ ngày đăng nhập đầu tiên của họ, sau đó chia số đó cho tổng số người chơi.*/
WITH twt_rank_nextdate AS(
SELECT player_id,event_date,
LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS next_date,
RANK() OVER(PARTITION BY player_id ORDER BY event_date) AS rank
FROM Activity
)
SELECT 
ROUND(
    SUM(CASE WHEN next_date-event_date = 1 THEN 1 ELSE 0 END)
    *1.0/COUNT(*),2) AS fraction
FROM twt_rank_nextdate
WHERE rank=1
