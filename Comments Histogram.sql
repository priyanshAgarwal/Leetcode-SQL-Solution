/*
Write a SQL query to create a histogram of the number of comments per user in the month of January 2020.

Note: Assume bin buckets class intervals of one.

Note: Comments by users that were not created in January 2020 should be counted in a “0” bucket

Important Concept 

Left Join and Filter.
*/



	WITH CTE AS (
    SELECT users.id, COUNT(comments.user_id) AS comment_count
	FROM users
	LEFT JOIN comments
	    ON users.id = comments.user_id
	        AND comments.created_at 
	        BETWEEN '2020-01-01' AND '2020-01-31'
	GROUP BY 1
    ORDER BY 1)


    SELECT comment_count, COUNT(DISTINCT ID) AS frequency 
    FROM CTE
    GROUP BY 1