=== FILE: sql/main/tables/DIM_CHANNEL_DEVICE.sql ===

CREATE TABLE fraud.DIM_CHANNEL_DEVICE (
    DeviceId NVARCHAR(50),
    ChannelType VARCHAR(30),
    DeviceRiskLevel VARCHAR(20),
    LocationCode NVARCHAR(20),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_CHANNEL_DEVICE.DeviceId -> FACT_IB_FRAUD.DeviceId.
UPDATE fraud.DIM_CHANNEL_DEVICE
SET DeviceRiskLevel = 'High'
WHERE ChannelType = 'WEB';
