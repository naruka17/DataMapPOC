=== FILE: sql/main/tables/DIM_DEVICE_RISK.sql ===

CREATE TABLE fraud.DIM_DEVICE_RISK (
    DeviceId NVARCHAR(50),
    DeviceRiskLevel VARCHAR(20),
    ChannelType VARCHAR(30),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_DEVICE_RISK.DeviceId -> FACT_* tables.DeviceId.
UPDATE fraud.DIM_DEVICE_RISK
SET DeviceRiskLevel = 'High'
WHERE ChannelType = 'POS';
