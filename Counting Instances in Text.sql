/*

Counting Instances in Text
Find the number of times the words 'bull' and 'bear' occur in the contents. We're counting 
the number of times the words occur so words like 'bullish' should not be included in our count.
Output the word 'bull' and 'bear' along with the corresponding number of occurrences.

filename	contents
draft1.txt	The stock exchange predicts a bull market which would make many investors happy.

draft2.txt	The stock exchange predicts a bull market which would make many investors happy, but
analysts warn of possibility of too 
much optimism and that in fact we are awaiting a bear market.

final.txt	The stock exchange predicts a bull market which would make many investors happy, 
but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear 
market. As always predicting the future market is an uncertain game and all investors should 
follow their instincts and best practices.

*/

--Method 1
select words, count(words) from (
select unnest(string_to_array(contents,' ')) as words from google_file_store) A
where words in ('bull','bear')
group by words

--Method 2
select 'Bear' as contents,count(*)
from google_file_store
where contents like '%bear%'
union all
select 'Bull' as contents,count(*)
from google_file_store
where contents like '%bull%'

--Method 3
select 'Bear' as contents,
sum(case when contents like '%bear%' then 1 else 0 end)
from google_file_store
union all
select 'Bull' as contents,
sum(case when contents like '%bull%' then 1 else 0 end)
from google_file_store

-- Method 4 
select  
    'bull'
    ,COUNT(regexp_match(contents, 'bull'))
from google_file_store
UNION ALL
select  
    'bear'
    ,COUNT(regexp_match(contents, 'bear'))
from google_file_store

