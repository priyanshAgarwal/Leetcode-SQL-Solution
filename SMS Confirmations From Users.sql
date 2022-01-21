/*

SMS Confirmations From Users
Meta/Facebook sends SMS texts when users attempt to 2FA (2-factor authenticate) into the platform to log in. In order to successfully 2FA they must confirm they received the SMS text message. Confirmation texts are only valid on the date they were sent. Unfortunately, there was an ETL problem with the database where friend requests and invalid confirmation records were inserted into the logs, which are stored in the 'fb_sms_sends' table. These message types should not be in the table. Fortunately, the 'fb_confirmers' table contains valid confirmation records so you can use this table to identify SMS text messages that were confirmed by the user.

Calculate the percentage of confirmed SMS texts for August 4, 2020.

*/

SELECT COUNT(A.*)*100.0/COUNT(B.*) FROM 
(SELECT PHONE_NUMBER FROM fb_confirmers
WHERE DATE='2020-08-04') A
RIGHT JOIN 
(SELECT PHONE_NUMBER FROM fb_sms_sends
WHERE DS='2020-08-04' AND TYPE='message') B
ON A.PHONE_NUMBER=B.PHONE_NUMBER

-- METHOD 2
select COUNT(A.phone_number)*100/COUNT(B.phone_number) from fb_confirmers A
RIGHT JOIN fb_sms_sends B
ON B.phone_number=A.phone_number AND B.DS=A.DATE
WHERE B.DS='2020-08-04' AND B.type ='message';
