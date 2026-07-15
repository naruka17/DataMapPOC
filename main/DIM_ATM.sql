=== FILE: sql/main/tables/DIM_ATM.sql ===

CREATE TABLE fraud.DIM_ATM (
    ATMId NVARCHAR(50),
    LocationCode NVARCHAR(20),
    DeviceRiskLevel VARCHAR(20),
    ChannelType VARCHAR(30),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_ATM.ATMId -> FACT_ATM_FRAUD.ATMId.
UPDATE fraud.DIM_ATM
SET DeviceRiskLevel = 'High'
WHERE LocationCode LIKE 'LOCATM%';
