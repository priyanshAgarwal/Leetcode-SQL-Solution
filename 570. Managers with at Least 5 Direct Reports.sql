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

SELECT * FROM
EMPLOYEE A INNER JOIN EMPLOYEE B
ON A.ID=B.MANAGERID

*/
--SELF JOIN 
SELECT A.NAME FROM
EMPLOYEE A INNER JOIN EMPLOYEE B
ON A.ID=B.MANAGERID
GROUP BY B.MANAGERID
HAVING COUNT(B.ID)>4

SELECT B.NAME FROM EMPLOYEE A 
INNER JOIN EMPLOYEE B
ON A.MANAGERID=B.ID
GROUP BY 1
HAVING COUNT(DISTINCT A.ID)>4

--SINGLE QUERY 

SELECT Name FROM Employee 
WHERE Id IN (SELECT DISTINCT ManagerID
FROM Employee
GROUP BY ManagerID
HAVING COUNT(ManagerID)>=5); 

--METHOD 1
with get_manager AS (
SELECT ManagerID
FROM Employee
GROUP BY ManagerID
HAVING COUNT(ManagerID)>=5)

SELECT Name FROM Employee 
WHERE Id IN (SELECT DISTINCT ManagerID FROM get_manager); 