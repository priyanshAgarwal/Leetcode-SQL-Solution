/*

Premium vs Freemium
Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.

Look Again
*/

WITH CTE AS (select A.*, C.paying_customer
FROM ms_download_facts A
LEFT JOIN ms_user_dimension B
ON A.user_id=B.user_id
LEFT JOIN ms_acc_dimension C
ON B.acc_id=C.acc_id)

SELECT
date,
SUM(CASE WHEN paying_customer='no' then downloads else null end) as non_paying,
SUM(CASE WHEN paying_customer='yes' then downloads else null end) as paying
FROM CTE
group by 1
having SUM(CASE WHEN paying_customer='no' then downloads else null end)>SUM(CASE WHEN paying_customer='yes' then downloads else null end)
order by 1
;


WITH CTE AS (select A.*, C.paying_customer
FROM ms_download_facts A
LEFT JOIN ms_user_dimension B
ON A.user_id=B.user_id
LEFT JOIN ms_acc_dimension C
ON B.acc_id=C.acc_id)

SELECT 
    DISTINCT 
        DATE,
        SUM(downloads) FILTER(WHERE paying_customer='no') OVER(PARTITION BY DATE) AS non_paying_customer,
        SUM(downloads) FILTER(WHERE paying_customer='yes') OVER(PARTITION BY DATE) AS paying_customer
FROM CTE;