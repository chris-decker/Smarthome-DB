--Create indexes on all Foreign Keys that are not also Primary Keys
CREATE INDEX AlertActionAccountIDIdx ON AlertAction(AccountID);
CREATE INDEX AlertActionStepActionIDIdx ON AlertActionStep(ActionID);
CREATE INDEX AlertActionStepAASTypeIDIdx ON AlertActionStep(AASTypeID);
CREATE INDEX AlertAccountIDIdx ON Alert(AccountID);
CREATE INDEX AlertZipCodeIdx ON Alert(ZipCode);
CREATE INDEX AlertActionIDIdx ON Alert(ActionID);
CREATE INDEX PaymentMethodAccountIDIdx ON PaymentMethod(AccountID);

--Create indexes that will be beneficial for current & potential queries
CREATE INDEX CreditCardAccountNumIdx ON CreditCard(AccountNum);
CREATE UNIQUE INDEX AccountEmailIdx ON Account(Email);
CREATE INDEX AlertTemperatureIdx ON Alert(Temperature);