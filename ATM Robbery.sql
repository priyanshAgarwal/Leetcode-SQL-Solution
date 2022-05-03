/*
ATM Robbery

There was a robbery from the ATM at the bank where you work. Some unauthorized withdrawals were made, and you need to help your bank find out more about those withdrawals.

However, the only information you have is that there was more than 1 withdrawal, they were all performed in 10-second gaps, and no legitimate transactions were performed in between two fraudulent withdrawals.

We’re given a table of bank transactions with three columns, user_id, a deposit or withdrawal value transaction_value, and created_at time for each transaction.

Write a query to retrieve all user IDs in ascending order whose transactions have exactly a 10-second gap from one another.

Note: Assume that there are only withdrawals from the ATM, which are denoted with a positive transaction_value

IMPORTANT cONCEPT AGAIN WHICH YOU MISSED, THAT CURRENT TRANSACTION CAN ALSO BE FRAUD, YOU WERE ONLY 
CONSIDERING NEXT TRANSACTION TO BE FRAUD. 

*/

WITH CTE AS (SELECT 
USER_ID,
CREATED_AT,
LEAD(CREATED_AT,1) OVER(ORDER BY CREATED_AT) AS NEXT_TRANSACTION,
LAG(CREATED_AT,1) OVER(ORDER BY CREATED_AT) AS PREVIOUS_TRANSACTION
FROM bank_transactions ),

CT2 AS (
SELECT USER_ID, 
ABS(TIMESTAMPDIFF(SECOND,CREATED_AT,NEXT_TRANSACTION)) AS NEXT_TIME_DIFF,
ABS(TIMESTAMPDIFF(SECOND,PREVIOUS_TRANSACTION,CREATED_AT)) AS PREVIOUS_TIME_DIFF 
FROM CTE)

SELECT DISTINCT USER_ID AS user_id FROM CT2
WHERE NEXT_TIME_DIFF=10 OR PREVIOUS_TIME_DIFF=10
ORDER BY 1


