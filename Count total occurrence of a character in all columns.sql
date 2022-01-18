/*

Count total occurrence of a character in all columns


In this puzzle you have to count value a from all the columns preferably with a single select keyword. Please check out the sample input and the expected output.

Sample Input

a1	a2	a3
a	d	a
c	e	f
a	a	s
a	 	a
a	a	s
Expected Output

a1	a2	a3	CountOfA’s
a	d	a	8
c	e	f	8
a	a	s	8
a	 	a	8
a	a	s	8

--
 
CREATE TABLE Counta
(
      a1 VARCHAR(1)
    , a2 VARCHAR(1)
    , a3 VARCHAR(1)
)
GO
 
INSERT INTO Counta VALUES
('a','d','a'),
('c','e','f'),
('a','a','s'),
('a','','a'),
('a','a','s')
GO
 
SELECT * FROM Counta
GO
 
--
*/

SELECT *    ,
   SUM(CASE WHEN A1='a' THEN 1 END) OVER()
  +SUM(CASE WHEN A2='a' THEN 1 END) OVER()
  +SUM(CASE WHEN A3='a' THEN 1 END) OVER()
AS CountOfA
FROM Counta
