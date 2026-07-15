=== FILE: sql/staging/tables/STG_ATM_CUSTOMER.sql ===

CREATE TABLE fraud_staging.STG_ATM_CUSTOMER (
    TxnId NVARCHAR(50),
    AccountId NVARCHAR(50),
    ATMId NVARCHAR(50),
    TxnTimestamp NVARCHAR(50),
    Amount NVARCHAR(50),
    CurrencyCode NVARCHAR(10),
    Channel NVARCHAR(30),
    DeviceId NVARCHAR(50),
    IPAddress NVARCHAR(50),
    LocationCode NVARCHAR(20),
    RiskScoreRaw NVARCHAR(20),
    FraudFlagRaw NVARCHAR(5),
    SourceSystemName NVARCHAR(50),
    SourceExtractTs NVARCHAR(50),
    LoadDts DATETIME,
    LoadRunId NVARCHAR(50)
);

-- Simple rule to mark high-risk ATM customer withdrawals.
UPDATE fraud_staging.STG_ATM_CUSTOMER
SET FraudFlagRaw = 'Y'
WHERE TRY_CAST(Amount AS DECIMAL(18,2)) > 18000;
