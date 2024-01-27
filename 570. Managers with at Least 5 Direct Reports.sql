/*
570. Managers with at Least 5 Direct Reports

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+

SELECT B.ID, B.NAME FROM Employee A
INNER JOIN Employee B 
ON A.ManagerId=B.ID
GROUP BY 1,2
HAVING COUNT(*)>=5


Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+

["id", "name", "department", "managerId", "id", "name", "department", "managerId"], 
[101, "John", "A", null, 102, "Dan", "A", 101],
[101, "John", "A", null, 103, "James", "A", 101], 
[101, "John", "A", null, 104, "Amy", "A", 101], 
[101, "John", "A", null, 105, "Anne", "A", 101], 
[101, "John", "A", null, 106, "Ron", "B", 101]]}

SELECT * FROM EMPLOYEE A
INNER JOIN EMPLOYEE B
ON A.MANAGERID = B.ID


| id  | name  | department | managerId | id   | name | department | managerId |
| --- | ----- | ---------- | --------- | ---- | ---- | ---------- | --------- |
| 101 | John  | A          | null      | null | null | null       | null      |
| 102 | Dan   | A          | 101       | 101  | John | A          | null      |
| 103 | James | A          | 101       | 101  | John | A          | null      |
| 104 | Amy   | A          | 101       | 101  | John | A          | null      |
| 105 | Anne  | A          | 101       | 101  | John | A          | null      |
| 106 | Ron   | B          | 101       | 101  | John | A          | null      |

Now we can simply group by managerId

*/
--SELF JOIN

SELECT B.NAME FROM EMPLOYEE A
INNER JOIN EMPLOYEE B
ON A.MANAGERID = B.ID
GROUP BY A.MANAGERID
HAVING COUNT(DISTINCT A.ID)>=5

--SINGLE QUERY 

SELECT Name FROM Employee 
WHERE Id IN (SELECT DISTINCT ManagerID
FROM Employee
GROUP BY ManagerID
HAVING COUNT(ManagerID)>=5); 

--METHOD 1
SELECT A.NAME
FROM EMPLOYEE A 
INNER JOIN 
(SELECT MANAGERID AS ID
FROM EMPLOYEE
GROUP BY MANAGERID
HAVING  COUNT(DISTINCT ID)>=5) AS B
ON A.ID = B.ID
