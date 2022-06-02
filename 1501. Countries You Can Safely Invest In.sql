/*

1501. Countries You Can Safely Invest In

Table Person:

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| name           | varchar |
| phone_number   | varchar |
+----------------+---------+
id is the primary key for this table.
Each row of this table contains the name of a person and their phone number.
Phone number will be in the form 'xxx-yyyyyyy' where xxx is the country code (3 characters) and yyyyyyy is the phone number (7 characters) where x and y are digits. Both can contain leading zeros.
 

Table Country:

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| name           | varchar |
| country_code   | varchar |
+----------------+---------+
country_code is the primary key for this table.
Each row of this table contains the country name and its code. country_code will be in the form 'xxx' where x is digits.
 

Table Calls:

+-------------+------+
| Column Name | Type |
+-------------+------+
| caller_id   | int  |
| callee_id   | int  |
| duration    | int  |
+-------------+------+
There is no primary key for this table, it may contain duplicates.
Each row of this table contains the caller id, callee id and the duration of the call in minutes. caller_id != callee_id
 

A telecommunications company wants to invest in new countries. The company intends to invest in the countries where the average call duration of the calls in this country is strictly greater than the global average call duration.

Write an SQL query to find the countries where this company can invest.

Return the result table in any order.

The query result format is in the following example:

 

Person table:
+----+----------+--------------+
| id | name     | phone_number |
+----+----------+--------------+
| 3  | Jonathan | 051-1234567  |
| 12 | Elvis    | 051-7654321  |
| 1  | Moncef   | 212-1234567  |
| 2  | Maroua   | 212-6523651  |
| 7  | Meir     | 972-1234567  |
| 9  | Rachel   | 972-0011100  |
+----+----------+--------------+

Country table:
+----------+--------------+
| name     | country_code |
+----------+--------------+
| Peru     | 051          |
| Israel   | 972          |
| Morocco  | 212          |
| Germany  | 049          |
| Ethiopia | 251          |
+----------+--------------+

Calls table:
+-----------+-----------+----------+
| caller_id | callee_id | duration |
+-----------+-----------+----------+
| 1         | 9         | 33       |
| 2         | 9         | 4        |
| 1         | 2         | 59       |
| 3         | 12        | 102      |
| 3         | 12        | 330      |
| 12        | 3         | 5        |
| 7         | 9         | 13       |
| 7         | 1         | 3        |
| 9         | 7         | 1        |
| 1         | 7         | 7        |
+-----------+-----------+----------+

Result table:
+----------+
| country  |
+----------+
| Peru     |
+----------+
The average call duration for Peru is (102 + 102 + 330 + 330 + 5 + 5) / 6 = 145.666667
The average call duration for Israel is (33 + 4 + 13 + 13 + 3 + 1 + 1 + 7) / 8 = 9.37500
The average call duration for Morocco is (33 + 4 + 59 + 59 + 3 + 7) / 6 = 27.5000 
Global call duration average = (2 * (33 + 4 + 59 + 102 + 330 + 5 + 13 + 3 + 1 + 7)) / 20 = 55.70000
Since Peru is the only country where average call duration is greater than the global average, it's the only recommended country.


["CALLER_ID", "DURATION", "COUNTRY"], 
[1, 33, "Morocco"], 
[2, 4, "Morocco"], 
[1, 59, "Morocco"], 
[3, 102, "Peru"], 
[3, 330, "Peru"], 
[12, 5, "Peru"], 
[7, 13, "Israel"], [7, 3, "Israel"], [9, 1, "Israel"], [1, 7, "Morocco"], [9, 33, "Morocco"], [9, 4, "Morocco"], [2, 59, "Morocco"], [12, 102, "Peru"], [12, 330, "Peru"], [3, 5, "Peru"], [9, 13, "Israel"], [1, 3, "Israel"], [7, 1, "Israel"], [7, 7, "Morocco"]]}
*/


-- Better Code

WITH PERSON AS (
SELECT A.ID, B.NAME AS COUNTRY 
FROM PERSON A
INNER JOIN COUNTRY B
ON LEFT(PHONE_NUMBER,3)=B.COUNTRY_CODE),

AVERAGE_DATA AS (
SELECT
    CALLER_ID,
    DURATION,
    COUNTRY
FROM CALLS A
INNER JOIN PERSON B
ON A.CALLER_ID=B.ID    
UNION ALL
SELECT
    CALLEE_ID,
    DURATION,
    COUNTRY
FROM CALLS A
INNER JOIN PERSON B
ON A.CALLER_ID=B.ID)

SELECT country   
FROM (SELECT 
    DISTINCT 
    B.COUNTRY, 
    AVG(DURATION) OVER(PARTITION BY B.COUNTRY) AS COUNTRY_AVG,
    AVG(DURATION) OVER() AS OVERALL_AVG
FROM AVERAGE_DATA A
INNER JOIN PERSON B
ON A.CALLER_ID=B.ID
) AS A
WHERE A.COUNTRY_AVG>A.OVERALL_AVG

-- # Write your MySQL query statement below

WITH COUNT_NAME_ID AS (
SELECT A.ID, B.NAME AS COUNTRY_NAME FROM 
(SELECT 
    ID, 
    NAME,
    LEFT(phone_number,3) AS COUNTRY_CODE
FROM Person) A
INNER JOIN Country B
ON A.COUNTRY_CODE=B.COUNTRY_CODE),


CALL_DURATION AS (SELECT 
        A.DURATION,
        B.COUNTRY_NAME
FROM Calls A
INNER JOIN COUNT_NAME_ID B
ON A.caller_id=B.ID
UNION ALL
SELECT 
        A.DURATION,
        B.COUNTRY_NAME
FROM Calls A
INNER JOIN COUNT_NAME_ID B
ON A.callee_id=B.ID),


AVG_DURATION AS (SELECT COUNTRY_NAME, SUM(DURATION)/COUNT(*) AS AVG_CALL_DURATION
FROM CALL_DURATION
GROUP BY COUNTRY_NAME)

SELECT COUNTRY_NAME AS COUNTRY FROM AVG_DURATION
WHERE AVG_CALL_DURATION>(SELECT AVG(DURATION) FROM CALL_DURATION)
