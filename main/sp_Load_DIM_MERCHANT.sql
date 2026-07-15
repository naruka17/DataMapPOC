=== FILE: sql/main/procs/sp_Load_DIM_MERCHANT.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_DIM_MERCHANT
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Merchant / POS transaction fraud.
    -- Purpose: Load merchant dimension records.
    -- Lineage: STG_MERCHANT_DEVICE -> main proc -> DIM_MERCHANT.

    INSERT INTO fraud.DIM_MERCHANT (
        MerchantId, MerchantCategory, ChannelType, DeviceRiskLevel, SourceSystemName, LoadDts
    )
    SELECT
        s.MerchantId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 7000 THEN 'HighRisk' ELSE 'Standard' END AS MerchantCategory,
        s.Channel AS ChannelType,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 7000 THEN 'High' ELSE 'Medium' END AS DeviceRiskLevel,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_MERCHANT_DEVICE s
    GROUP BY s.MerchantId, s.Channel, s.SourceSystemName, s.LoadDts, s.Amount;
END;
