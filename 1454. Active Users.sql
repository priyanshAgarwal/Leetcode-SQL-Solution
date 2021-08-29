/*

1454. Active Users
Medium

Table Accounts:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
the id is the primary key for this table.
This table contains the account id and the user name of each account.
 

Table Logins:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

Write an SQL query to find the id and the name of active users.

Active users are those who logged in to their accounts for 5 or more consecutive days.

Return the result table ordered by the id.

The query result format is in the following example:

Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+

Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+

Result table:
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.
Follow up question:
Can you write a general solution if the active users are those who logged in to their accounts for n or more consecutive days?

{"headers": ["id", "login_date", "LOGIN_RANK", "DATE_GROUPING"], "values": [
    [27, "2020-06-26", 1, "2020-06-25"], 
    [27, "2020-06-27", 2, "2020-06-25"], 
    [27, "2020-06-28", 3, "2020-06-25"], 
    [27, "2020-06-29", 4, "2020-06-25"], 
    [27, "2020-06-29", 4, "2020-06-25"], 
    [27, "2020-07-01", 5, "2020-06-26"], 
    [27, "2020-07-02", 6, "2020-06-26"], 
    [27, "2020-07-04", 7, "2020-06-27"], 
    [31, "2020-06-26", 1, "2020-06-25"], 
    [31, "2020-06-28", 2, "2020-06-26"], 
    [31, "2020-06-29", 3, "2020-06-26"], 
    [31, "2020-06-29", 3, "2020-06-26"], 
    [31, "2020-06-30", 4, "2020-06-26"], 
    [31, "2020-07-02", 5, "2020-06-27"], 
    [31, "2020-07-02", 5, "2020-06-27"], 
    [31, "2020-07-03", 6, "2020-06-27"], 
    [31, "2020-07-03", 6, "2020-06-27"], 
    [31, "2020-07-04", 7, "2020-06-27"], 
    [49, "2020-06-30", 1, "2020-06-29"], 
    [49, "2020-07-01", 2, "2020-06-29"], 
    [49, "2020-07-02", 3, "2020-06-29"], 
    [49, "2020-07-03", 4, "2020-06-29"], 
    [49, "2020-07-04", 5, "2020-06-29"],
    [49, "2020-07-05", 6, "2020-06-29"], 
    [119, "2020-06-26", 1, "2020-06-25"]



*/
