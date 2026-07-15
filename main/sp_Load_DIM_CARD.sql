=== FILE: sql/main/procs/sp_Load_DIM_CARD.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_DIM_CARD
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Credit card fraud monitoring.
    -- Purpose: Build or refresh card dimension data.
    -- Lineage: STG_CARD_TXN -> main proc -> DIM_CARD.

    INSERT INTO fraud.DIM_CARD (
        CardId, CustomerSegment, RiskLevel, ChannelType, SourceSystemName, LoadDts
    )
    SELECT
        s.CardId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 50000 THEN 'HighValue' ELSE 'Standard' END AS CustomerSegment,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 50000 THEN 'High' ELSE 'Medium' END AS RiskLevel,
        s.Channel AS ChannelType,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_CARD_TXN s
    GROUP BY s.CardId, s.Channel, s.SourceSystemName, s.LoadDts, s.Amount;
END;
