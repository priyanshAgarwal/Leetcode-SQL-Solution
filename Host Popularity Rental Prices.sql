/*

Host Popularity Rental Prices
You’re given a table of rental property searches by users. The table consists of search results and outputs host information for searchers. Find the minimum, average, maximum rental prices for each host’s popularity rating. The host’s popularity rating is defined as below:
    0 reviews: New
    1 to 5 reviews: Rising
    6 to 15 reviews: Trending Up
    16 to 40 reviews: Popular
    more than 40 reviews: Hot

Tip: The `id` column in the table refers to the search ID. You'll need to create your own host_id by concating price, room_type, host_since, zipcode, and number_of_reviews.

Output host popularity rating and their minimum, average and maximum rental prices.

Look Again

*/

select 
    case 
    when number_of_reviews=0 then 'New'
    when number_of_reviews>=1 and number_of_reviews<=5 then 'Rising'
    when number_of_reviews>=6 and number_of_reviews<=15 then 'Trending Up'
    when number_of_reviews>=16 and number_of_reviews<=40 then 'Popular'
    else 'Hot'
    end as host_pop_rating
,min(price),avg(price),max(price) from (select price, room_type, host_since, zipcode, number_of_reviews
    from airbnb_host_searches group by 1,2,3,4,5) as a group by 1;


