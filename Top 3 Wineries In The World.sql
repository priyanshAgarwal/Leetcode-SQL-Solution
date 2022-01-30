/*

Top 3 Wineries In The World
Find the top 3 wineries in each country based on the average points earned. Output the country along with the best, second best, and third best wineries. If there is no second winery (NULL value) output 'No second winery' and if there is no third winery output 'No third winery'. For outputting wineries format them like this: "winery (avg_points)"

Very Important Concept
*/


WITH CTE AS (SELECT *, 
    ROW_NUMBER() OVER(PARTITION BY COUNTRY ORDER BY avg_point DESC ROWS BETWEEN unbounded preceding and current row) AS WINE_RANK 
    FROM (
    select winery,Country,ROUND(AVG(Points)) AS avg_point from winemag_p1 GROUP BY 1,2) AS A)
    
    
SELECT 
country, 
MAX(CASE WHEN wine_rank=1 THEN concat(winery, ' (', avg_point, ')') END) AS "top_winery",
COALESCE(MAX(CASE WHEN wine_rank=2 THEN concat(winery, ' (', avg_point, ')') END),'No second winery') AS "second_winery",
COALESCE(MAX(CASE WHEN wine_rank=3 THEN concat(winery, ' (', avg_point, ')') END),'No third winery') AS "third_winery"
FROM CTE
GROUP BY 1
ORDER BY 1;


-- Very Important Concept (What if You want to Show All First, Second, Third)

WITH CTE AS (SELECT *, 
    DENSE_RANK() OVER(PARTITION BY COUNTRY ORDER BY avg_point DESC ROWS BETWEEN unbounded preceding and current row) AS WINE_RANK 
    FROM (
    select winery,Country,ROUND(AVG(Points)) AS avg_point from winemag_p1 GROUP BY 1,2) AS A),
    
CTE_2 AS (   
SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY country,wine_rank ORDER BY wine_rank) AS WINE_ROW FROM CTE ) AS A
WHERE A.wine_rank<=3)

SELECT country, COALESCE(MAX(CASE WHEN wine_rank=1 THEN concat(winery, ' (', avg_point, ')') END),'N/A') AS "TOP_WINERY",
MAX(CASE WHEN wine_rank=2 THEN concat(winery, ' (', avg_point, ')') END) AS "SECOND_WINERY",
MAX(CASE WHEN wine_rank=3 THEN concat(winery, ' (', avg_point, ')') END) AS "THIRD_WINERY"
FROM CTE_2
GROUP BY country,wine_row
ORDER BY 1
