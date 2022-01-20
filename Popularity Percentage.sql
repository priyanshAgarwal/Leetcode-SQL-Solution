/*

Popularity Percentage
Find the popularity percentage for each user on Meta/Facebook. The popularity percentage is defined 
as the total number of friends the user has divided by the total number of users on the platform, 
then converted into a percentage by multiplying by 100.
Output each user along with their popularity percentage. Order records in ascending order by user id.
The 'user1' and 'user2' column are pairs of friends.

*/

with all_friends as(
select user1 as user_id from facebook_friends
union all
select user2 as user_id from facebook_friends)

select user_id, round(count(*)*100/ count(*) over()::decimal,3) from all_friends
group by user_id
order by user_id;