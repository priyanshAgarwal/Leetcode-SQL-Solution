/*

City With Most Amenities
You're given a dataset of searches for properties on Airbnb. For simplicity, let's say that each search result (i.e., each row) represents a unique host. Find the city with the most amenities across all their host's properties. Output the name of the city.


*/

WITH CTE AS (   
 SELECT CITY,UNNEST(string_to_array(BTRIM(amenities,'{}'), ',')) AS AMENITIES FROM airbnb_search_details)
 
 
SELECT CITY FROM ( SELECT CITY, DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT AMENITIES) DESC) FROM CTE
 GROUP BY 1) AS A
 WHERE A.dense_rank=1;