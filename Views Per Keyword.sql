/*
Views Per Keyword
Create a report showing how many views each keyword has. Output the keyword and the total views, and order records with highest view count first.
Tables: facebook_posts, facebook_post_views

*/

select UNNEST(STRING_TO_ARRAY(BTRIM(post_keywords,'[]#'),',')), COUNT(viewer_id)
from facebook_posts A
LEFT JOIN facebook_post_views B
ON A.post_id=B.post_id
GROUP BY 1