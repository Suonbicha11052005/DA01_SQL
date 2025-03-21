/*Viết giải pháp hoán đổi id chỗ ngồi của hai học sinh liên tiếp. Nếu số học sinh là số lẻ, id của học sinh cuối cùng sẽ không được hoán đổi.

Trả về bảng kết quả được sắp xếp theo id thứ tự tăng dần .*/
--C1: LEAD(),LAG() khong thay doi gia tri cua id
SELECT id,
CASE
    WHEN id%2=0 THEN LAG(student) OVER(ORDER BY id)
    WHEN id%2=1 AND LEAD(student) OVER(ORDER BY id) IS NOT NULL THEN LEAD(student) OVER(ORDER BY id)
    ELSE student
END AS student
FROM Seat
ORDER BY id
--C2: Thay doi gia tri cua id lay cot student lam co dinh
SELECT
CASE
    WHEN id % 2 = 0 THEN id - 1
    WHEN id % 2 = 1 AND id+1<=(SELECT COUNT(*) FROM Seat) THEN id+1
    ELSE id
END AS id,
student
FROM Seat
ORDER BY id
