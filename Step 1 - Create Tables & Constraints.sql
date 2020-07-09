--drop tables if they exist
DROP TABLE triggerstatuschange;
DROP TABLE triggeredalert;
DROP TABLE alert;
DROP TABLE window;
DROP TABLE thermostat;
DROP TABLE phone;
DROP TABLE email;
DROP TABLE smarthome;
DROP TABLE alertactionstep;
DROP TABLE alertaction;
DROP TABLE paypal;
DROP TABLE creditcard;
DROP TABLE banktransfer;
DROP TABLE paymentmethod;
DROP TABLE currenttemp;
DROP TABLE paymentmethodtype;
DROP TABLE alertactionsteptype;
DROP TABLE account;
--create all tables with no foreign keys first
CREATE TABLE account
(accountid  NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 email      VARCHAR(255) NOT NULL UNIQUE, 
 [password] VARCHAR(255) NOT NULL, 
 lastpaid   DATE, 
 autobill   BIT NOT NULL
);
CREATE TABLE alertactionsteptype
(aastypeid   NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 aastypedesc VARCHAR(255) NOT NULL
);
CREATE TABLE paymentmethodtype
(pmtypeid   NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 pmtypedesc VARCHAR(255) NOT NULL
);
CREATE TABLE currenttemp
(zipcode     CHAR(5)
 PRIMARY KEY, 
 temperature NUMERIC(3)
);
--create tables with foregin keys, starting from the ones that only reference the tables that have been created and working out
CREATE TABLE paymentmethod
(methodid  NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 accountid NUMERIC(12) NOT NULL
                       REFERENCES account, 
 pmtypeid  NUMERIC(12) NOT NULL
                       REFERENCES paymentmethodtype, 
 isdefault BIT NOT NULL
);
CREATE TABLE banktransfer
(methodid   NUMERIC(12)
 PRIMARY KEY
 REFERENCES paymentmethod, 
 routingnum NUMERIC(20) NOT NULL, 
 accountnum NUMERIC(20) NOT NULL
);
CREATE TABLE creditcard
(methodid   NUMERIC(12)
 PRIMARY KEY
 REFERENCES paymentmethod, 
 firstname  VARCHAR(255) NOT NULL, 
 lastname   VARCHAR(255) NOT NULL, 
 billingzip CHAR(5) NOT NULL, 
 accountnum NUMERIC(16) NOT NULL, 
 expmonth   NUMERIC(2) NOT NULL
                       CHECK(expmonth >= 1
                             AND expmonth <= 12), 
 expyear    NUMERIC(2) NOT NULL
);
CREATE TABLE paypal
(methodid NUMERIC(12)
 PRIMARY KEY
 REFERENCES paymentmethod, 
 pplemail VARCHAR(255) NOT NULL
);
CREATE TABLE alertaction
(actionid  NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 accountid NUMERIC(12) NOT NULL
                       REFERENCES account
);
CREATE TABLE alertactionstep
(stepid    NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 actionid  NUMERIC(12) NOT NULL
                       REFERENCES alertaction, 
 aastypeid NUMERIC(12) NOT NULL
                       REFERENCES alertactionsteptype
);
CREATE TABLE smarthome
(stepid     NUMERIC(12)
 PRIMARY KEY
 REFERENCES alertactionstep, 
 ipaddress  VARCHAR(15) NOT NULL, 
 macaddress VARCHAR(17) NOT NULL
);
CREATE TABLE email
(stepid     NUMERIC(12)
 PRIMARY KEY
 REFERENCES alertactionstep, 
 alertemail VARCHAR(255) NOT NULL
);
CREATE TABLE phone
(stepid     NUMERIC(12)
 PRIMARY KEY
 REFERENCES alertactionstep, 
 alertphone NUMERIC(10) NOT NULL
);
CREATE TABLE thermostat
(stepid  NUMERIC(12)
 PRIMARY KEY
 REFERENCES alertactionstep, 
 settemp NUMERIC(3) NOT NULL
);
CREATE TABLE window
(stepid NUMERIC(12)
 PRIMARY KEY
 REFERENCES alertactionstep, 
 isopen BIT NOT NULL
);
CREATE TABLE alert
(alertid     NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 accountid   NUMERIC(12) NOT NULL
                         REFERENCES account, 
 zipcode     CHAR(5) NOT NULL
                     REFERENCES currenttemp, 
 actionid    NUMERIC(12) NOT NULL
                         REFERENCES alertaction, 
 temperature NUMERIC(3) NOT NULL, 
 ismax       BIT NOT NULL, 
 triggered   BIT NOT NULL
);
CREATE TABLE triggeredalert
(alertid NUMERIC(12)
 PRIMARY KEY
 REFERENCES alert
);
CREATE TABLE triggerstatuschange
(tschangeid NUMERIC(12) IDENTITY(1, 1) PRIMARY KEY, 
 alertid    NUMERIC(12) NOT NULL
                        REFERENCES alert, 
 changedate DATE NOT NULL, 
 oldval     BIT NOT NULL, 
 newval     BIT NOT NULL
);