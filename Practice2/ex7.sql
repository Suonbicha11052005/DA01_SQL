/*Viết truy vấn xuất ra tên từng thẻ tín dụng và chênh lệch số lượng 
thẻ phát hành giữa tháng có số thẻ phát hành cao nhất và tháng có số 
hẻ phát hành thấp nhất. Sắp xếp kết quả dựa trên độ chênh lệch lớn 
nhất ( tu lon den be )*/
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;
