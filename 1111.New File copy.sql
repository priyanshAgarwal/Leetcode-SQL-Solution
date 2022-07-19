/*

Products                              Sales
# # +------------------+---------+           +------------------+---------+
# # | product_id       | int     |-----------| product_id       |int      |
# # | product_class    | int     |  +--------| store_id         |int      |
# # | brand_name       | varchar |  |  +-----| customer_id      |int      |
# # | product_name     | varchar |  |  |     | promotion_id     |int      |
# # | price            | int     |  |  |     | store_sales      |decimal  |
# # +------------------+---------+  |  |     | store_cost       |decimal  |
# #                                 |  |     | units_sold       |decimal  |
# #                                 |  |     | transaction_date |date     |
# #                                 |  |     +------------------+---------+
# #                                 |  |
# # stores                          |  |  customers
# # +-------------------+---------+ |  |  +---------------------+---------+
# # | store_id          | int     |-+  +--| customer_id        | int      |
# # | type              | varchar |       | first_name         | varchar  |
# # | name              | varchar |       | last_name          | varchar  |
# # | state             | varchar |       | state              | varchar  |
# # | first_opened_date | datetime|       | birthdate          | date     |
# # | last_remodel_date | datetime|       | education          | varchar  |
# # | area_sqft         | int     |       | gender             | varchar  |
# # +-------------------+---------+       | date_account_opened| date     |
# #                                       +---------------------+---------+

Find out what the top 3 selling product classes are, by total sales?

Question a.Percentage of transactions made by store=’Smart Shop’

SELECT COUNT(DISTINCT CASE WHEN A.NAME='Smart Shop' THEN TTRANSACTION_ID END)*100.0/COUNT(DISTINCT TRANACTIONS_ID) 
FROM STORES A
INNER JOIN SALES B
ON A.STORE_ID=B/STORE_ID 
*/
