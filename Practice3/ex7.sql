/*Viết giải pháp để tìm số lượng người dùng hoạt động hàng ngày trong một khoảng thời gian gồm 30nhiều ngày kết thúc 2019-07-27bằng bao gồm. Một người dùng hoạt động vào một ngày nào đó nếu họ thực hiện ít nhất một hoạt động vào ngày đó.*/
SELECT activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE DATEDIFF('2019-07-27',activity_date) BETWEEN 0 AND 29
/*WHERE DATEDIFF('2019-07-27',activity_date)<=29 AND activity_date<='2019-07-27'*/
GROUP BY activity_date
