/*Write a query that calculates the total viewership for laptops 
and mobile devices where mobile is defined as the sum of tablet and 
phone viewership. Output the total viewership for laptops as 
laptop_reviews and the total viewership for mobile devices as 
mobile_views.*/
/*Viết truy vấn tính toán tổng lượng người xem cho máy tính xách tay
và thiết bị di động, trong đó thiết bị di động được định nghĩa là 
tổng lượng người xem máy tính bảng và điện thoại. Xuất tổng lượng
người xem cho máy tính xách tay là laptop_reviews và tổng lượng 
người xem cho thiết bị di động là mobile_views.*/
SELECT 
SUM(CASE
  WHEN device_type = 'laptop' THEN 1
  ELSE 0
END) AS laptop_reviews,
SUM(CASE
  WHEN device_type IN ('tablet','phone') THEN 1
  ELSE 0
END) AS mobile_views
FROM viewership
