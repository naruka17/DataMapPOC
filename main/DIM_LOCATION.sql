=== FILE: sql/main/tables/DIM_LOCATION.sql ===

CREATE TABLE fraud.DIM_LOCATION (
    LocationCode NVARCHAR(20),
    Region VARCHAR(50),
    RiskLevel VARCHAR(20),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_LOCATION.LocationCode -> FACT_* tables.LocationCode.
UPDATE fraud.DIM_LOCATION
SET RiskLevel = 'High'
WHERE Region = 'Urban';
