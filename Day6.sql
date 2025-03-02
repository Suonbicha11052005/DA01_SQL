--LOWER-UPPER-LENGTH CHALLENGE
--Liet ke cac khach hang co ho hoac ten co nhieu hon 10 ki tu. Xuat ra dang chu thuong
SELECT LOWER(first_name) AS lower_first_name,
LOWER(last_name) AS lower_last_name
FROM customer
WHERE LENGTH(last_name)>10 OR LENGTH(first_name)>10;
--LEFT-RIGHT CHALLENGE
--Trich xuat 5 ki tu cuoi cung cua dia chi email
--Bk dia chi email luon ket thuc '.org'
--Trich xuat dau cham tu dia chi email
SELECT RIGHT(email,5) AS five_char_right,
LEFT(RIGHT(email,4),1) AS char
FROM customer;
--NOI CHUOI CHALLENGE
--De bao mat du lieu, yeu cau hay mask dia chi email nhu sau:
--MARRY.SMITH@sakilacustomer.org -> MAR***H@sakilacustomer.org
SELECT email,
LEFT(email,3) || '***' || RIGHT(email,20) 
FROM customer;
