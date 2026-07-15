=== FILE: sql/main/tables/DIM_CARD.sql ===

CREATE TABLE fraud.DIM_CARD (
    CardId NVARCHAR(50),
    CustomerSegment VARCHAR(50),
    RiskLevel VARCHAR(20),
    ChannelType VARCHAR(30),
    SourceSystemName NVARCHAR(50),
    LoadDts DATETIME
);

-- Relationship: DIM_CARD.CardId -> FACT_CARD_FRAUD.CardId.
UPDATE fraud.DIM_CARD
SET RiskLevel = 'High'
WHERE CustomerSegment = 'HighValue';
