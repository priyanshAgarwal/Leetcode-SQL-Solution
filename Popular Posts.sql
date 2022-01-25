/*


Popular Posts
The column 'perc_viewed' in the table 'post_views' denotes the percentage of the session duration time the user spent viewing a post. Using it, calculate the total time that each post was viewed by users. Output post ID and the total viewing time in seconds, but only for posts with a total viewing time of over 5 seconds. 

Look Again
*/

select * from post_views;
with sessions as (
select session_id, (extract(EPOCH
                  FROM session_endtime::TIME) - extract (epoch from session_starttime::time)) AS Seconds from user_sessions)
                  
select a.post_id,SUM(b.seconds*(perc_viewed/100.0)) from post_views a
left join sessions b
on a.session_id=b.session_id
GROUP BY post_id
HAVING SUM(b.seconds*(perc_viewed/100.0))>5;