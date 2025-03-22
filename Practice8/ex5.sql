/*Viết giải pháp báo cáo tổng giá trị đầu tư trong năm 2016 tiv_2016cho tất cả người được bảo hiểm:

có cùng tiv_2015giá trị với một hoặc nhiều người được bảo hiểm khác và
không nằm trong cùng thành phố với bất kỳ người được bảo hiểm nào khác (tức là lat, loncặp thuộc tính ( ) phải là duy nhất).
Làm tròn tiv_2016đến hai chữ số thập phân*/
--C1: Dung GROUP BY de lay cac tiv_2015 va lat,lon t/m 
SELECT ROUND(CAST(SUM(tiv_2016) AS DECIMAL),2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN(
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*)>1
)
AND (lat,lon) IN(
    SELECT lat,lon
    FROM Insurance
    GROUP BY lat,lon
    HAVING COUNT(*)=1
)
--C2: Kho hieu hon
SELECT ROUND(CAST(SUM(tiv_2016) AS DECIMAL),2) AS tiv_2016
FROM Insurance AS a
WHERE a.tiv_2015 IN(
    SELECT b.tiv_2015 FROM Insurance AS b WHERE b.pid <> a.pid
) AND (a.lat,a.lon) NOT IN(
    SELECT b.lat,b.lon FROM Insurance AS b WHERE b.pid <> a.pid
)
