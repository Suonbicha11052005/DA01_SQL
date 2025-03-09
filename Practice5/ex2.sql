/*Một nhà phân tích cấp cao muốn biết tỷ lệ kích hoạt của những người dùng được chỉ định trong bảng emails. Viết truy vấn để tìm tỷ lệ kích hoạt. 
Làm tròn phần trăm đến 2 chữ số thập phân.
Nhà phân tích quan tâm đến tỷ lệ kích hoạt của những người dùng cụ thể trong bảng email, bảng này có thể không bao gồm tất cả những người dùng 
có khả năng được tìm thấy trong bảng văn bản.*/
--Ty le kich hoat = so nguoi xac nhan confirmed/ so nguoi dang ki
SELECT ROUND(CAST(SUM(
CASE
  WHEN t2.signup_action='Confirmed' THEN 1
  ELSE 0
END) AS DECIMAL)/COUNT(DISTINCT t1.email_id),2) AS confirm_rate
FROM emails AS t1
LEFT JOIN texts AS t2
ON t1.email_id=t2.email_id
--COUNT(CASE...WHEN...THEN t1.email_id END)
