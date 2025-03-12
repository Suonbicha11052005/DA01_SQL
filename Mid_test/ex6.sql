/*Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.*/
SELECT t1.address
FROM address AS t1
LEFT JOIN customer AS t2
ON t1.address_id=t2.address_id
WHERE t2.address_id IS NULL
