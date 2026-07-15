=== FILE: sql/staging/tables/STG_MERCHANT_CUSTOMER.sql ===

CREATE TABLE fraud_staging.STG_MERCHANT_CUSTOMER (
    TxnId NVARCHAR(50),
    MerchantId NVARCHAR(50),
    CustomerId NVARCHAR(50),
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

-- Simple rule to flag high-risk merchant-customer transactions.
UPDATE fraud_staging.STG_MERCHANT_CUSTOMER
SET FraudFlagRaw = 'Y'
WHERE TRY_CAST(Amount AS DECIMAL(18,2)) > 6500;
