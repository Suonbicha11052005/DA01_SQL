/*Viết truy vấn để có được sự phân tích về thời gian gửi so với thời gian mở snap dưới dạng phần trăm tổng 
thời gian dành cho các hoạt động này được nhóm theo nhóm tuổi. Làm tròn phần trăm đến 2 chữ số thập phân trong đầu ra.
Lưu ý:
Tính các phần trăm sau:
thời gian gửi / (Thời gian gửi + Thời gian mở)
Thời gian mở / (Thời gian gửi + Thời gian mở)*/
SELECT t1.age_bucket,
ROUND(SUM(CASE
  WHEN t2.activity_type='send' THEN t2.time_spent 
END)*100.0/SUM(t2.time_spent),2) AS send_perc,
ROUND(SUM(CASE
  WHEN t2.activity_type='open' THEN t2.time_spent 
END)*100.0/SUM(t2.time_spent),2) AS open_perc
FROM age_breakdown AS t1
JOIN activities AS t2
ON t1.user_id=t2.user_id
WHERE t2.activity_type!='chat'
GROUP BY t1.age_bucket
