/*Có một hàng người đang xếp hàng chờ lên xe buýt. Tuy nhiên, xe buýt có giới hạn trọng lượng là 1000kilôgam 
vì vậy có thể có một số người không thể lên xe.
Viết giải pháp để tìm person_namengười cuối cùng có thể ngồi vừa trên xe buýt mà không vượt quá giới hạn trọng lượng.
Các trường hợp thử nghiệm được tạo ra sao cho người đầu tiên không vượt quá giới hạn trọng lượng.*/
SELECT person_name
FROM(
    SELECT person_name,
    SUM(weight) OVER(ORDER BY turn) AS sum_weight
    FROM Queue
)
WHERE sum_weight<=1000
ORDER BY sum_weight DESC
LIMIT 1
