/*Trong SQL, (x, y, z) là cột khóa chính cho bảng này.
Mỗi hàng của bảng này chứa độ dài của ba đoạn thẳng.
Báo cáo xem ba đoạn thẳng có thể tạo thành một hình tam giác hay không.
Trả về bảng kết quả theo bất kỳ thứ tự nào .*/
SELECT x,y,z,
CASE
    WHEN x+y>z AND x+z>y AND y+z>x THEN 'Yes'
    ELSE 'No'
END AS triangle
FROM Triangle
