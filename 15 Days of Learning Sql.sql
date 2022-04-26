/*
15 Days of Learning Sql
*/

CREATE TABLE EMPLOYEE (
    DMPL YE Lid Integer S    START_date DATE,
    END_date DATE,   NAME VARCHAR
);

INSERT INTO EMPLOYEE (EMPLOYEE_id, START_date, END_date, NAME)
VALUES (1,'1/1/2010','1/4/2018','John'),
       (2,'1/1/2010','1/5/2020','Mary'),
       (3,'2/3/2012',NULL,'Tom'),
       (4,'4/5/2015',NULL,'Rita'),
       (5,'5/3/2015',NULL,'Sam'),
       (6,'5/5/2016','1/5/2020','Harry'),
       (7,'5/5/2016','1/20/2020','Ron'),
       (8,'2/6/2017',NULL,'Josh'),
       (9,'4/7/2017',NULL,'Krish'),
       (10,'10/8/2017',NULL,'Kevin');

With temp as (
  select
    t.dates,
    ROW_NUMBER() over(
      order by
        dates asc
    ) as row_num
  from
    (
      select
        start_date as dates
      from
        EMPLOYEE
      Union all
      select
        COALESCE(end_date, now()) as dates
      from
        EMPLOYEE
    ) as t
)

Select
  max(tmp.leader-tmp.lagger)
from
  (
    select
      t1.dates as leader,
    t2.dates as lagger
    from
      temp t1
      inner join temp t2 on t1.row_num = t2.row_num +1
  ) as tmp


SELECT DISTINCT CONCAT(A.FIRSTNAME,' ',A.SURNAME) AS MEMBER, C.NAME AS FACILITY, 
FROM CD.MEMBERS A 
INNER JOIN CD.BOOKINGS B
ON A.MEMID=B.MEMID
INNER JOIN CD.FACILITIES C
ON B.FACID=C.FACID
WHERE DATE(B.STARTTIME) = '2012-09-14'
ORDER BY 1,2


SELECT DISTINCT CONCAT(A.FIRSTNAME,' ',A.SURNAME) AS MEMBER, C.NAME AS FACILITY, 
	CASE WHEN A.FIRSTNAME='GUEST' AND A.SURNAME='GUEST' THEN GUESTCOST ELSE MEMBERCOST END
	AS COST
FROM CD.MEMBERS A 
INNER JOIN CD.BOOKINGS B
ON A.MEMID=B.MEMID
INNER JOIN CD.FACILITIES C
ON B.FACID=C.FACID
WHERE DATE(B.STARTTIME) = '2012-09-14'
ORDER BY 1,2

select CONCAT(mems.firstname ,' ', mems.surname) as member, bks.FACID
        from
                cd.members mems                
                inner join cd.bookings bks
                        on mems.memid = bks.memid
        where
		bks.starttime >= '2012-09-14' and 
		bks.starttime < '2012-09-15'
		ORDER BY 1





