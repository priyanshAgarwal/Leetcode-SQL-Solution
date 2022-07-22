/*

Find fare differences on the Titanic using a self join

Find the average absolute fare difference between a specific passenger and all passengers that belong to the same pclass,  both are non-survivors and age difference between two of them is 5 or less years. Do that for each passenger (that satisfy above mentioned coniditions). Output the result along with the passenger name.

*/

SELECT A.NAME, AVG(ABS(A.FARE-B.FARE)) FROM 
titanic a, titanic b
WHERE a.pclass=b.pclass 
AND a.survived = 0 
AND b.survived = 0
AND a.passengerid!=b.passengerid
AND ABS(A.AGE-B.AGE)<=5
GROUP BY 1;
