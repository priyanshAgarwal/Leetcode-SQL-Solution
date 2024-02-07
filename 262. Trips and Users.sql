/*
262. Trips and Users


Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03".

The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Return the result table in any order. Round Cancellation Rate to two decimal points.

The query result format is in the following example:

 

Trips table:
+----+-----------+-----------+---------+---------------------+------------+
| Id | Client_Id | Driver_Id | City_Id | Status              | Request_at |
+----+-----------+-----------+---------+---------------------+------------+
| 1  | 1         | 10        | 1       | completed           | 2013-10-01 |
| 2  | 2         | 11        | 1       | cancelled_by_driver | 2013-10-01 |
| 3  | 3         | 12        | 6       | completed           | 2013-10-01 |
| 4  | 4         | 13        | 6       | cancelled_by_client | 2013-10-01 |
| 5  | 1         | 10        | 1       | completed           | 2013-10-02 |
| 6  | 2         | 11        | 6       | completed           | 2013-10-02 |
| 7  | 3         | 12        | 6       | completed           | 2013-10-02 |
| 8  | 2         | 12        | 12      | completed           | 2013-10-03 |
| 9  | 3         | 10        | 12      | completed           | 2013-10-03 |
| 10 | 4         | 13        | 12      | cancelled_by_driver | 2013-10-03 |
+----+-----------+-----------+---------+---------------------+------------+

Users table:
+----------+--------+--------+
| Users_Id | Banned | Role   |
+----------+--------+--------+
| 1        | No     | client |
| 2        | Yes    | client |
| 3        | No     | client |
| 4        | No     | client |
| 10       | No     | driver |
| 11       | No     | driver |
| 12       | No     | driver |
| 13       | No     | driver |
+----------+--------+--------+

Result table:
+------------+-------------------+
| Day        | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 | 0.33              |
| 2013-10-02 | 0.00              |
| 2013-10-03 | 0.50              |
+------------+-------------------+

On 2013-10-01:
  - There were 4 requests in total, 2 of which were canceled.
  - However, the request with Id=2 was made by a banned client (User_Id=2), so it is ignored in the calculation.
  - Hence there are 3 unbanned requests in total, 1 of which was canceled.
  - The Cancellation Rate is (1 / 3) = 0.33
On 2013-10-02:
  - There were 3 requests in total, 0 of which were canceled.
  - The request with Id=6 was made by a banned client, so it is ignored.
  - Hence there are 2 unbanned requests in total, 0 of which were canceled.
  - The Cancellation Rate is (0 / 2) = 0.00
On 2013-10-03:
  - There were 3 requests in total, 1 of which was canceled.
  - The request with Id=8 was made by a banned client, so it is ignored.
  - Hence there are 2 unbanned request in total, 1 of which were canceled.
  - The Cancellation Rate is (1 / 2) = 0.50

["Id", "Client_Id", "Driver_Id", "City_Id", "Status", "Request_at"]
[1, 1, 10, 1, "completed", "2013-10-01"],
[2, 2, 11, 1, "cancelled_by_driver", "2013-10-01"], 
[3, 3, 12, 6, "completed", "2013-10-01"], 
[4, 4, 13, 6, "cancelled_by_client", "2013-10-01"], 
[5, 1, 10, 1, "completed", "2013-10-02"], 
[6, 2, 11, 6, "completed", "2013-10-02"],
[7, 3, 12, 6, "completed", "2013-10-02"],
[8, 2, 12, 12, "completed", "2013-10-03"], 
[9, 3, 10, 12, "completed", "2013-10-03"], 
[10, 4, 13, 12, "cancelled_by_driver", "2013-10-03"]

*/

SELECT
    REQUEST_AT AS day,
    ROUND(COUNT(CASE WHEN STATUS<>'completed' THEN ID ELSE NULL END)*1.0/COUNT(DISTINCT ID),2) AS "Cancellation Rate"
FROM Trips
WHERE Client_Id NOT IN (SELECT DISTINCT USERS_ID FROM USERS WHERE BANNED = 'YES')
AND Driver_Id  NOT IN (SELECT DISTINCT USERS_ID FROM USERS WHERE BANNED = 'YES')
AND Request_at between '2013-10-01' and '2013-10-03'
GROUP BY 1;

-- Method 2 (Best method we are not usinig not in here which can be expensive)
# Write your MySQL query statement below
WITH CTE AS (
SELECT A.* FROM TRIPS A
LEFT JOIN USERS B
ON A.CLIENT_ID = B.users_id and b.role='client'
LEFT JOIN USERS C
ON A.driver_id = C.users_id and c.role='driver'
WHERE B.BANNED = 'No' AND C.BANNED = 'No')

SELECT request_at AS DAY, ROUND(COUNT(DISTINCT CASE WHEN LEFT(STATUS,9)='cancelled' THEN ID ELSE NULL END)*1.00/COUNT(DISTINCT ID),2) AS "Cancellation Rate"
FROM CTE
WHERE REQUEST_AT BETWEEN "2013-10-01" AND "2013-10-03"
GROUP BY 1



-- Method 3
WITH TOTAL_RIDES AS (
SELECT 
    REQUEST_AT,
    SUM(CASE WHEN STATUS <> 'completed' THEN 1 ELSE 0 END) AS CANCELLED_RISED,
    COUNT(*) AS TOTAL_RIDES
FROM TRIPS 
WHERE CLIENT_ID NOT IN (SELECT USERS_ID FROM USERS WHERE ROLE='client' AND BANNED='Yes')
AND DRIVER_ID NOT IN (SELECT USERS_ID FROM USERS WHERE ROLE='driver' AND BANNED='Yes')
AND REQUEST_AT between '2013-10-01' and '2013-10-03' 
GROUP BY REQUEST_AT)



SELECT REQUEST_AT AS DAY, 
ROUND(CANCELLED_RISED/TOTAL_RIDES,2) AS 'CANCELLATION RATE' FROM TOTAL_RIDES;