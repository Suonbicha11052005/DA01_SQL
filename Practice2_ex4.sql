/*Bạn đang cố gắng tìm số lượng mặt hàng trung bình trên mỗi đơn hàng
trên Alibaba, được làm tròn đến 1 chữ số thập phân bằng cách sử dụng 
các bảng bao gồm thông tin về số lượng mặt hàng trong mỗi đơn hàng 
(bảng item_count) và số lượng đơn hàng tương ứng cho mỗi số lượng 
mặt hàng (bảng order_occurrences).
mean = so luong mat hang / so don hang (so mat hang trung binh 
tren 1 don hang)
ROUND(FLOAT,INTERGER)
Muon chuyen tu int sang float CAST(INT AS DECIMAL)
*/
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences)
AS DECIMAL),1) AS mean
FROM items_per_order;
