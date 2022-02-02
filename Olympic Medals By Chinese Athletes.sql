/*
Olympic Medals By Chinese Athletes
Find the number of medals earned in each category by Chinese athletes from the 2000 to 2016 summer Olympics. For each medal category, calculate the number of medals for each olympic games along with the total number of medals across all years. Sort records by total medals in descending order.

Look Again
Made Mistake
Very Important Concept
*/

WITH CTE AS (SELECT medal, 
    COUNT(CASE WHEN year='2000' THEN MEDAL ELSE NULL END) AS medals_2000,
    COUNT(CASE WHEN year='2004' THEN MEDAL ELSE NULL END) AS medals_2004,
    COUNT(CASE WHEN year='2008' THEN MEDAL ELSE NULL END) AS medals_2008,
    COUNT(CASE WHEN year='2012' THEN MEDAL ELSE NULL END) AS medals_2012,
    COUNT(CASE WHEN year='2016' THEN MEDAL ELSE NULL END) AS medals_2016,
    COUNT(*)
FROM olympics_athletes_events
WHERE team = 'China'
GROUP BY medal)

SELECT * FROM CTE;

-- Method 2
-- Very Important Concept
WITH MEDAL_LIST AS (
SELECT DISTINCT medal,
COUNT(*) FILTER(WHERE YEAR = 2000) over (partition by medal) as medals_2000,
COUNT(*) FILTER(WHERE YEAR = 2004) over (partition by medal) as medals_2004,
COUNT(*) FILTER(WHERE YEAR = 2008) over (partition by medal) as medals_2008,
COUNT(*) FILTER(WHERE YEAR = 2012) over (partition by medal) as medals_2012,
COUNT(*) FILTER(WHERE YEAR = 2016) over (partition by medal) as medals_2016,
COUNT(*) OVER(partition by medal) AS total_medals
FROM olympics_athletes_events
WHERE medal IS NOT NULL
AND team = 'China'

)

SELECT * FROM MEDAL_LIST