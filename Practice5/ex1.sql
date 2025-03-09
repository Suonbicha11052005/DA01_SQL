/*Với các bảng CITY và COUNTRY , hãy truy vấn tên của tất cả các châu lục ( COUNTRY.Continent ) và dân số trung bình của các thành phố tương ứng ( CITY.Population ) được làm tròn xuống số nguyên gần nhất.

Lưu ý: CITY.CountryCode và COUNTRY.Code là các cột khóa khớp nhau.*/
SELECT t1.Continent,FLOOR(AVG(t2.Population)) AS avg_population
FROM COUNTRY AS t1
JOIN CITY AS t2
ON t1.Code = t2.CountryCode
GROUP BY t1.Continent
