/*

Recommendation System
You are given the list of Meta/Facebook friends and the list of Meta/Facebook pages that users follow. Your task is to create a new recommendation system for Meta/Facebook. For each Meta/Facebook user, find pages that this user doesn't follow but at least one of their friends does. Output the user ID and the ID of the page that should be recommended to this user.

Look Again
*/


WITH friends_pages AS (
    SELECT DISTINCT A.USER_ID, b.page_id AS friend_page_id
    FROM users_friends a
    JOIN users_pages b ON a.friend_id = b.user_id)
    

SELECT * FROM friends_pages
WHERE (user_id, friend_page_id) NOT IN (SELECT user_id, page_id FROM users_pages)
ORDER BY 1


