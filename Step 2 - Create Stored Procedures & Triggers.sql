DROP PROCEDURE newaccount;  
GO  
DROP PROCEDURE addcreditcard;  
GO  
DROP TRIGGER status_change_trg;  
GO  

--create newaccount procedure
CREATE PROCEDURE newaccount @email    VARCHAR(255), 
                            @password VARCHAR(255), 
                            @autobill BIT
AS
     BEGIN
         DECLARE @last_paid DATE;
         DECLARE @hashed_pass VARCHAR(255);
         SET @last_paid = CONVERT(DATE, GETDATE());
         SET @hashed_pass = HASHBYTES('MD5', @password);
         BEGIN
             INSERT INTO account
             (email, 
              [password], 
              lastpaid, 
              autobill
             )
             VALUES
             (@email, 
              @hashed_pass, 
              @last_paid, 
              @autobill
             );
         END;
     END;
GO

--create addcreditcard procedure
CREATE PROCEDURE addcreditcard @account NUMERIC(12), 
                               @default BIT, 
                               @fname   VARCHAR(255), 
                               @lname   VARCHAR(255), 
                               @billzip CHAR(5), 
                               @ccnum   NUMERIC(16), 
                               @month   NUMERIC(2), 
                               @year    NUMERIC(2)
AS
     BEGIN
         IF NOT EXISTS
         (
             SELECT *
             FROM paymentmethod
             WHERE accountid = @account
         )
             SET @default = 1;
         BEGIN
             INSERT INTO paymentmethod(accountid, pmtypeid, isdefault)
         VALUES(@account, 1, @default);
             INSERT INTO creditcard(methodid, firstname, lastname, billingzip, accountnum, expmonth, expyear)
             VALUES(@@identity, @fname, @lname, @billzip, @ccnum, @month, @year);
         END;
     END;
GO

--create status_change_trg trigger
CREATE TRIGGER status_change_trg ON alert
AFTER UPDATE
AS
     BEGIN
         DECLARE @alertid NUMERIC(12);
         DECLARE @changedate DATE;
         DECLARE @oldval BIT;
         DECLARE @newval BIT;
         SET @alertid =
         (
             SELECT inserted.alertid
             FROM inserted
         );
         SET @changedate = CONVERT(DATE, GETDATE());
         SET @oldval =
         (
             SELECT deleted.triggered
             FROM deleted
         );
         SET @newval =
         (
             SELECT inserted.triggered
             FROM inserted
         );
         BEGIN
             INSERT INTO triggerstatuschange
             (alertid, 
              changedate, 
              oldval, 
              newval
             )
             VALUES
             (@alertid, 
              @changedate, 
              @oldval, 
              @newval
             );
         END;
     END;
GO