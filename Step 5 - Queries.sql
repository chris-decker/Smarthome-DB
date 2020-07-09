--This query displays all of the unique account email addresses and Paypal email addresses for every account which has a Visa card as a payment method
SELECT account.email
FROM account
WHERE account.accountid IN
(
    SELECT account.accountid
    FROM account
         INNER JOIN paymentmethod ON account.accountid = paymentmethod.accountid
         INNER JOIN creditcard ON paymentmethod.methodid = creditcard.methodid
    WHERE(creditcard.accountnum BETWEEN 2345000000000000 AND 2345999999999999)
)
UNION
SELECT paypal.pplemail
FROM account
     INNER JOIN paymentmethod ON account.accountid = paymentmethod.accountid
     INNER JOIN paypal ON paymentmethod.methodid = paypal.methodid
WHERE account.accountid IN
(
    SELECT account.accountid
    FROM account
         INNER JOIN paymentmethod ON account.accountid = paymentmethod.accountid
         INNER JOIN creditcard ON paymentmethod.methodid = creditcard.methodid
    WHERE(creditcard.accountnum BETWEEN 2345000000000000 AND 2345999999999999)
);

--This query determines the number of each payment method type our customers use and ranks them in descending order
SELECT paymentmethodtype.pmtypedesc, 
       COUNT(paymentmethod.methodid) AS typecount
FROM paymentmethod
     INNER JOIN paymentmethodtype ON paymentmethod.pmtypeid = paymentmethodtype.pmtypeid
GROUP BY paymentmethodtype.pmtypedesc
ORDER BY COUNT(paymentmethod.methodid) DESC;

--This query displays the email addresses for all current accounts which have not had an alert trigger in the past 30 days
SELECT account.email
FROM account
WHERE account.accountid NOT IN
(
    SELECT alert.accountid
    FROM triggerstatuschange
         INNER JOIN alert ON triggerstatuschange.alertid = alert.alertid
    WHERE(triggerstatuschange.newval = 1)
         AND (triggerstatuschange.changedate >= DATEADD(day, -30, GETDATE()))
)
    AND account.lastpaid >= DATEADD(day, -30, GETDATE());