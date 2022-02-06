/*

1098. Unpopular Books

Table: Books

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key of this table.
Table: Orders

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key of this table.
book_id is a foreign key to the Books table.
 

Write an SQL query that reports the books that have sold less than 10 copies in the last year, 
excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

The query result format is in the following example:

Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | "Kalila And Demna" | 2010-01-01     |
| 2       | "28 Letters"       | 2012-05-12     |
| 3       | "The Hobbit"       | 2019-06-10     |
| 4       | "13 Reasons Why"   | 2019-06-01     |
| 5       | "The Hunger Games" | 2008-09-21     |
+---------+--------------------+----------------+

Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+

Result table:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 1         | "Kalila And Demna" |
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |
+-----------+--------------------+


["NAME", "AVAILABLE_FROM", "QUANTITY", "DISPATCH_DATE"],
["Kalila And Demna", "2010-01-01", 1, "2018-11-05"], 
["Kalila And Demna", "2010-01-01", 2, "2018-07-26"], 
["The Hobbit", "2019-06-10", 8, "2019-06-11"], 
["13 Reasons Why", "2019-06-01", 5, "2019-06-20"], 
["13 Reasons Why", "2019-06-01", 6, "2019-06-05"]]}


*/

select b.book_id, b.name
from books b left join
    (select book_id, sum(quantity) as book_sold
    from Orders 
    where dispatch_date between '2018-06-23' and '2019-06-23'
    group by book_id) t
on b.book_id = t.book_id
where available_from < '2019-05-23'
and (book_sold is null or book_sold <10)
order by b.book_id;

-- # Write your MySQL query statement below

SELECT BOOK_ID,NAME FROM (SELECT 
    A.BOOK_ID,
    A.NAME,
    COALESCE(SUM(B.QUANTITY),0) AS QUANTITY_SOLD
FROM BOOKS A 
LEFT JOIN ORDERS B
ON A.BOOK_ID=B.BOOK_ID
AND DISPATCH_DATE BETWEEN DATE_ADD('2019-06-23', INTERVAL -1 YEAR) AND '2019-06-23'
WHERE AVAILABLE_FROM < DATE_ADD('2019-06-23', INTERVAL -30 DAY)
GROUP BY 1,2) AS A
WHERE A.QUANTITY_SOLD<10