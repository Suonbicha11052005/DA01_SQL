/*Bạn là chủ nhà hàng và muốn phân tích khả năng mở rộng (sẽ có ít nhất một khách hàng mỗi ngày).
Cac ngay phai lien tiep
Tính trung bình động của số tiền khách hàng đã thanh toán trong khung thời gian bảy ngày (tức là ngày hiện tại + 6 ngày trước đó). average_amountnên được làm tròn đến hai chữ số thập phân .

Trả về bảng kết quả được sắp xếp theo visited_on thứ tự tăng dần .*/
--Tinh sum(amount) moi ngay 
--Tinh sum ,avg trong 7 ngay ke tu ngay hien tai
--sau do moi loc ket qua where, neu loc trong ham tinh sum,avg se bi mat gia tri cua 6 ngay dau dan den k dung ket qua
WITH twt_total_daily_day AS(
    SELECT visited_on,
    SUM(amount) AS amount_daily
    FROM Customer
    GROUP BY visited_on
),
twt_result AS(
SELECT visited_on,
SUM(amount_daily) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
ROUND(AVG(amount_daily) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount
FROM twt_total_daily_day)
SELECT visited_on,amount,average_amount
FROM twt_result
WHERE visited_on >= (SELECT MIN(visited_on) FROM Customer) + INTERVAL '6 day'
ORDER BY visited_on
