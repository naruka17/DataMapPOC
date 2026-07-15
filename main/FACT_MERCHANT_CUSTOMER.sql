=== FILE: sql/main/tables/FACT_MERCHANT_CUSTOMER.sql ===

CREATE TABLE fraud.FACT_MERCHANT_CUSTOMER (
    TxnId NVARCHAR(50),
    MerchantId NVARCHAR(50),
    CustomerId NVARCHAR(50),
    TxnTimestamp DATETIME,
    Amount DECIMAL(18,2),
    CurrencyCode VARCHAR(10),
    Channel VARCHAR(30),
    DeviceId NVARCHAR(50),
    LocationCode NVARCHAR(20),
    FraudScore DECIMAL(5,2),
    ConfirmedFraudFlag VARCHAR(1),
    CaseId NVARCHAR(50),
    RiskBand VARCHAR(20),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: FACT_MERCHANT_CUSTOMER.MerchantId -> DIM_MERCHANT.MerchantId.
UPDATE fraud.FACT_MERCHANT_CUSTOMER
SET RiskBand = 'High'
WHERE FraudScore >= 0.89;
