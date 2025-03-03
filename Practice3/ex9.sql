/*Find the position of the lower case letter 'a' in the first name of the worker 'Amitah'.*/
select POSITION('a' IN first_name) AS position
from worker
WHERE first_name = 'Amitah'
