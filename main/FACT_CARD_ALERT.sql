=== FILE: sql/main/tables/FACT_CARD_ALERT.sql ===

CREATE TABLE fraud.FACT_CARD_ALERT (
    TxnId NVARCHAR(50),
    CardId NVARCHAR(50),
    AccountId NVARCHAR(50),
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

-- Relationship: FACT_CARD_ALERT.CardId -> DIM_CARD.CardId.
UPDATE fraud.FACT_CARD_ALERT
SET RiskBand = 'High'
WHERE FraudScore >= 0.9;
