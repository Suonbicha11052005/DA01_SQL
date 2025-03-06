/*UnitedHealth Group (UHG) có một chương trình có tên là Advocate4Me,
cho phép người sở hữu hợp đồng bảo hiểm (hoặc thành viên) gọi cho
người ủng hộ và nhận hỗ trợ cho nhu cầu chăm sóc sức khỏe của 
họ - cho dù đó là hỗ trợ khiếu nại và quyền lợi, bảo hiểm thuốc,
ủy quyền trước và sau, hồ sơ y tế, hỗ trợ khẩn cấp hay dịch vụ 
cổng thông tin thành viên.
Các cuộc gọi đến tổng đài Advocate4Me được phân loại thành nhiều 
loại khác nhau, nhưng một số cuộc gọi không thể được phân loại rõ 
ràng. Những cuộc gọi không được phân loại này được gắn nhãn là "n/a" 
hoặc để trống khi nhân viên hỗ trợ không nhập bất kỳ thông tin nào 
vào trường danh mục cuộc gọi.
Viết truy vấn để tính tỷ lệ phần trăm các cuộc gọi không thể phân
loại. Làm tròn câu trả lời của bạn đến 1 chữ số thập phân. 
Ví dụ: 45,0, 48,5, 57,7.*/
SELECT 
ROUND(SUM(CASE
  WHEN call_category = 'n/a' OR call_category IS NULL THEN 1
  ELSE 0
END)*100.0/COUNT(*),1) AS uncategorised_call_pct
FROM callers
