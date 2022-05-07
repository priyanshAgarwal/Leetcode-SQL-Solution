/*
Retention Rate


Find the monthly retention rate of users for each account separately for Dec 2020 and Jan 2021. Retention rate is the percentage of active users an account retains over a given period of time. In this case, assume the user is retained if he/she stays with the app in any future months. For example, if a user was active in Dec 2020 and has activity in any future month, consider them retained for Dec. You can assume all accounts are present in Dec 2020 and Jan 2021. Your output should have the account ID and the Jan 2021 retention rate divided by Dec 2020 retention rate.
*/

--Method 1
WITH USER_LIFE_CYCLE AS (
SELECT 
    ACCOUNT_ID,
    USER_ID,
    DATE_FORMAT(MIN(DATE),'%Y-%m') AS ENTRY_DATE,
    DATE_FORMAT(MAX(DATE),'%Y-%m') AS EXIT_DATE
FROM sf_events
GROUP BY 1,2
),

CTE2 AS ( 
SELECT *, 
    CASE WHEN  EXIT_DATE>'2020-12' THEN 1 ELSE 0 END AS DEC_RETENTION,
    CASE WHEN  EXIT_DATE>'2021-01' THEN 1 ELSE 0 END AS JAN_RETENTION
FROM USER_LIFE_CYCLE)

SELECT ACCOUNT_ID, ROUND(SUM(JAN_RETENTION)/SUM(DEC_RETENTION)) FROM CTE2
GROUP BY 1;

-- Additional Retention Rate
with user_lifecycle as (
    select account_id
    , user_id
    , date_format(min(date), '%Y-%m') as start_month
    , date_format(max(date), '%Y-%m') as end_month
    from sf_events
    group by user_id
),

monthly_retention as (
    select 
        distinct
        concat(a.account_id,' ',a.user_id) as user,
        date_format(date, '%Y-%m') as date,
        case when date_format(date, '%Y-%m')<b.end_month then 1 else 0 end as retention 
        from sf_events a
        inner join user_lifecycle b
        on a.account_id=b.account_id and a.user_id=b.user_id
)

select 
    date,
    count(distinct case when retention=1 then user else null end)/count(distinct user) as retention_rate
from monthly_retention
group by 1;

--Method 2 (Not Sure About this Approach)
with cte as(
select 
    account_id,
    user_id,
    DATE_FORMAT(date,'%Y-%m') as current_month,
    lead(DATE_FORMAT(date,'%Y-%m'),1) over(partition by account_id,user_id order by date) as next_month
from sf_events
where date between '2020-11-30' and '2021-02-28'),

cte2 as (
select 
    distinct account_id,
    user_id,
    (case when next_month>'2020-12' then 1 else 0 end) as dec_retention,
    (case when next_month>'2021-01' then 1 else 0 end) as jan_retention 
    -- reason we are doing next_month and next_2_month because we are interested in users who were already retained for previous month
from cte)


select account_id, ceil(sum(jan_retention)/coalesce(sum(dec_retention),null)) as retention from cte2
where dec_retention=1 or jan_retention=1
group by 1;
