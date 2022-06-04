/*

597. Friend Requests I: Overall Acceptance Rate
Easy

242

600

Add to List

Share
SQL Schema
Table: FriendRequest

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| sender_id      | int     |
| send_to_id     | int     |
| request_date   | date    |
+----------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date of the request.


*/



SELECT 
COALESCE(ROUND(COUNT(DISTINCT CONCAT(requester_id,',',accepter_id))/ COUNT(DISTINCT CONCAT(sender_id ,',',send_to_id)),2),0) AS accept_rate
FROM FriendRequest, RequestAccepted


