/*Các giám đốc điều hành của một công ty quan tâm đến việc xem ai kiếm được nhiều tiền nhất trong mỗi phòng ban của công ty. 
Người kiếm được nhiều tiền nhất trong một phòng ban là nhân viên có mức lương nằm trong ba mức lương cao nhất của phòng ban đó.
Viết giải pháp để tìm ra những nhân viên có thu nhập cao ở mỗi phòng ban.
Trả về bảng kết quả theo bất kỳ thứ tự nào .*/
WITH twt_rank_department AS(
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) as rank
    FROM Employee
)
SELECT b.name AS Department,a.name AS Employee,a.salary AS Salary
FROM twt_rank_department AS a
JOIN Department AS b
ON a.departmentId=b.id
WHERE a.rank<=3
