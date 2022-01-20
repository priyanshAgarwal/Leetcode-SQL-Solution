/*

The Cheapest Airline Connection
COMPANY X employees are trying to find the cheapest flights to upcoming conferences. When people fly long distances, a direct city-to-city flight is often more expensive than taking two flights with a stop in a hub city. Travelers might save even more money by breaking the trip into three flights with two stops. But for the purposes of this challenge, let's assume that no one is willing to stop three times! You have a table with individual airport-to-airport flights, which contains the following columns:

   • id - the unique ID of the flight;
   • origin - the origin city of the current flight;
   • destination - the destination city of the current flight;
   • cost - the cost of current flight.

Your task is to produce a trips table that lists all the cheapest possible trips that can be done in two or fewer stops. This table should have the columns origin, destination and total_cost (cheapest one). Sort the output table by origin, then by destination. The cities are all represented by an abbreviation composed of three uppercase English letters. Note: A flight from SFO to JFK is considered to be different than a flight from JFK to SFO.

Example of the output:
origin | destination | total_cost 
DFW | JFK | 200


This is Important Question (Recursion)
*/

WITH RECURSIVE FLIGHTS AS(
SELECT ORIGIN, DESTINATION, COST, 1 AS CONNECTTION FROM DA_FLIGHTS
UNION ALL
SELECT B.ORIGIN, B.DESTINATION, A.COST+B.COST, B.CONNECTTION+1 AS CONNECTTION
FROM DA_FLIGHTS A
INNER JOIN FLIGHTS B 
ON A.DESTINATION=B.ORIGIN
)

SELECT ORIGIN, DESTINATION, MIN(COST) AS COST FROM FLIGHTS
GROUP BY 1,2;


-- Method 2

WITH ONE_STOP AS (
    SELECT 
        A.ORIGIN,
        B.DESTINATION,
        A.COST+B.COST AS COST,
        2 AS STOP 
    FROM DA_FLIGHTS A
    INNER JOIN DA_FLIGHTS B ON A.DESTINATION=B.ORIGIN
),

TWO_STOP AS (
    SELECT 
        A.ORIGIN,
        B.DESTINATION,
        A.COST+B.COST AS COST,
        3 AS STOP 
    FROM DA_FLIGHTS A
    INNER JOIN ONE_STOP B ON A.DESTINATION=B.ORIGIN
),

ALL_FLIGHTS AS (
    SELECT ORIGIN, DESTINATION, COST, 1 AS STOPS FROM DA_FLIGHTS
    UNION ALL
    SELECT ORIGIN, DESTINATION, COST, STOP
    FROM ONE_STOP
    UNION ALL
    SELECT ORIGIN, DESTINATION, COST, STOP
    FROM TWO_STOP
)


SELECT ORIGIN, DESTINATION, MIN(COST) AS MIN_COST
FROM ALL_FLIGHTS
GROUP BY 1,2