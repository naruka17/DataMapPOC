=== FILE: sql/main/tables/DIM_CUSTOMER.sql ===

CREATE TABLE fraud.DIM_CUSTOMER (
    CustomerId NVARCHAR(50),
    CustomerSegment VARCHAR(50),
    RiskLevel VARCHAR(20),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_CUSTOMER.CustomerId -> FACT_* tables.CustomerId.
UPDATE fraud.DIM_CUSTOMER
SET RiskLevel = 'High'
WHERE CustomerSegment = 'HighValue';
