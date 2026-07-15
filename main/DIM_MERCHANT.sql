=== FILE: sql/main/tables/DIM_MERCHANT.sql ===

CREATE TABLE fraud.DIM_MERCHANT (
    MerchantId NVARCHAR(50),
    MerchantCategory VARCHAR(50),
    ChannelType VARCHAR(30),
    DeviceRiskLevel VARCHAR(20),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_MERCHANT.MerchantId -> FACT_MERCHANT_FRAUD.MerchantId.
UPDATE fraud.DIM_MERCHANT
SET DeviceRiskLevel = 'High'
WHERE MerchantCategory = 'HighRisk';
