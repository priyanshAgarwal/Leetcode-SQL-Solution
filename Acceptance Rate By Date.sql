/*

Acceptance Rate By Date
What is the overall friend acceptance rate by date? Your 
output should have the rate of acceptances by the date the request was sent. 
Order by the earliest date to latest.

Assume that each friend request starts by a user sending (i.e., user_id_sender) a friend
request to another user (i.e., user_id_receiver) that's logged in the table with action = 'sent'. 
If the request is accepted, the table logs action = 'accepted'. If the request is not accepted, 
no record of action = 'accepted' is logged.


*/

WITH CTE AS (
    SELECT
    user_id_sender,
    user_id_receiver,
    MAX(CASE WHEN action = 'sent' THEN date END) AS sent_date, 
    SUM(CASE WHEN action = 'sent' THEN 1 ELSE 0 END) AS sent, 
    SUM(CASE WHEN action = 'accepted' THEN 1 ELSE 0 END) AS accepted
    FROM fb_friend_requests
    GROUP BY 1,2)
    
SELECT sent_date,AVG(ACCEPTED/SENT) FROM CTE  
GROUP BY sent_date;

-- METHOD 2

WITH SENT AS (
SELECT 
	USER_ID_SENDER,
	USER_ID_RECEIVER,
	DATE AS SEND_DATE
FROM fb_friend_requests
WHERE ACTION ='sent'),

ACCEPTED AS(
SELECT 
	USER_ID_SENDER,
	USER_ID_RECEIVER,
	DATE AS RECEIVE_DATE
FROM fb_friend_requests
WHERE ACTION ='accepted'
)


SELECT B.SEND_DATE AS DATE, COUNT(A.USER_ID_RECEIVER)/COUNT(B.USER_ID_SENDER)::DECIMAL
FROM ACCEPTED A
RIGHT JOIN SENT B
ON A.USER_ID_SENDER=B.USER_ID_SENDER
AND A.USER_ID_RECEIVER=B.USER_ID_RECEIVER
GROUP BY 1;


-- Method 3


select a.date , 
    count(b.user_id_receiver):: decimal/ count(a.user_id_sender):: decimal  as percentage_acceptance
from (select * from  fb_friend_requests where action = 'sent') a
left join (select * from  fb_friend_requests where action = 'accepted') b
 ON a.user_id_sender=b.user_id_sender
 AND a.user_id_receiver = b.user_id_receiver 
group by a.date