--DDL: CREATE-ALTER-DROP
--Truy van du lieu lay ra danh sach khach hang va dia chi tuong ung
--sau do luu thong tin do vao bang va dat ten customer_info (bang vat ly)
CREATE TABLE customer_info AS(
SELECT customer_id,first_name||last_name AS full_name,email,b.address
FROM customer AS a
JOIN address AS b
ON a.address_id=b.address_id
)
--CREATE TEMPORY 
--Tao 1 bang tam thoi su dung khi ch dong tab
--CREATE [GLOBAL](cho phep nhieu nguoi su dung) TEMP TABLE <Ten bang> AS
--CREATE VIEW 
--Tao 1 bang ao de khi cac bang con dc cap nhat thay doi thi bang dc tao cx dc cap nhat
--CREATE [OR REPLACE](neu muon cap nhap bang] VIEW <Ten bang> AS, DROP VIEW
--CREATE VIEW CHALLENGE
--Tao view co ten movies_category hien thi danh sach cac film bao gom title,length,category name dc sx giam dan theo length
--Loc ket qua de chi nhung film trong danh muc 'Action','Comedy'
CREATE OR REPLACE VIEW movies_category AS(
SELECT a.title,a.length,c.name AS category_name
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
ORDER BY a.length DESC
)
SELECT * FROM movies_category
WHERE category_name IN('Action','Comedy')
--DML: INSERT,UPDATE,DELETE,truncate
--UPDATE CHALLENGE
--1.update gia cho thue film 0.99 thanh 1.99
UPDATE film
SET rental_rate = 1.99
WHERE rental_rate = 0.99
SELECT * FROM film
WHERE rental_rate=0.99
--2. Dieu chinh bang customer nhu sau:
--Them cot initials (varchar(10))
--Update du lieu vao cot initials
ALTER TABLE customer
ADD column initials VARCHAR(10)
SELECT * FROM customer
UPDATE customer
SET initials=LEFT(first_name,1)||'.'||LEFT(last_name,1)
