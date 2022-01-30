/*




*/

select * from 
(select distinct name from olympics_athletes_events 
where year=1992
AND team = 'Norway'
AND sport = 'Alpine Skiing') A
left join 
(select distinct name from olympics_athletes_events 
WHERE year=1994
AND team = 'Norway'
AND sport = 'Alpine Skiing') b
on a.name=b.name
and b.name is null

select distinct name from olympics_athletes_events 
where year=1992
AND team = 'Norway'
AND sport = 'Alpine Skiing'
and name not in (
select distinct name from olympics_athletes_events 
where year=1994
AND team = 'Norway'
AND sport = 'Alpine Skiing'
)


select distinct name from olympics_athletes_events 
where year=1992
AND team = 'Norway'
AND sport = 'Alpine Skiing'
and year!=1994


SELECT DISTINCT name
FROM olympics_athletes_events
WHERE team = 'Norway'
  AND sport = 'Alpine Skiing'
  AND YEAR = 1992
EXCEPT
SELECT name
FROM olympics_athletes_events
WHERE YEAR = 1994