/*Write a solution to report the movies with an odd-numbered ID (so le) and a description that is not "boring".
Return the result table ordered by rating in descending order(thu tu giam dan)
*/
SELECT * FROM Cinema
WHERE id%2 = 1 AND description != 'boring'
ORDER BY rating DESC;
