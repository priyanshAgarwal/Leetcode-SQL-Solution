/*

578. Get Highest Answer Rate Question
Medium

60

670

Add to List

Share
SQL Schema
Get the highest answer rate question from a table survey_log with these columns: id, action, question_id, answer_id, q_num, timestamp.

id means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", while is null for "show" and "skip"; q_num is the numeral order of the question in current session.

Write a sql query to identify the question which has the highest answer rate.

Example:

Input:
+------+-----------+--------------+------------+-----------+------------+
| id   | action    | question_id  | answer_id  | q_num     | timestamp  |
+------+-----------+--------------+------------+-----------+------------+
| 5    | show      | 285          | null       | 1         | 123        |
| 5    | answer    | 285          | 124124     | 1         | 124        |
| 5    | show      | 369          | null       | 2         | 125        |
| 5    | skip      | 369          | null       | 2         | 126        |
+------+-----------+--------------+------------+-----------+------------+
Output:
+-------------+
| survey_log  |
+-------------+
|    285      |
+-------------+
Explanation:
question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.

*/

WITH ANSWER_RATE AS (SELECT *, ROUND((ANSWER/SHOW_ANS)*ANSWER,2) AS ANS_RATE FROM 
          (SELECT 
            QUESTION_ID, 
            SUM(CASE WHEN action='SHOW' THEN 1 ELSE 0 END) AS SHOW_ANS,
            SUM(CASE WHEN action='ANSWER' THEN 1 ELSE 0 END) AS ANSWER
           FROM SURVEY_LOG
           GROUP BY QUESTION_ID) AS A)
           
           
SELECT QUESTION_ID AS SURVEY_LOG FROM (
  SELECT *, DENSE_RANK() OVER(ORDER BY ANS_RATE DESC) AS RATE_RANK
  FROM ANSWER_RATE
) AS A
WHERE A.RATE_RANK=1;