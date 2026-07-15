=== FILE: sql/main/procs/sp_Load_DIM_ATM.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_DIM_ATM
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: ATM withdrawal fraud monitoring.
    -- Purpose: Load ATM dimensions for downstream fraud reporting.
    -- Lineage: STG_ATM_LOCATION -> main proc -> DIM_ATM.

    INSERT INTO fraud.DIM_ATM (
        ATMId, LocationCode, DeviceRiskLevel, ChannelType, SourceSystemName, LoadDts
    )
    SELECT
        s.ATMId,
        s.LocationCode,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 15000 THEN 'High' ELSE 'Medium' END AS DeviceRiskLevel,
        s.Channel AS ChannelType,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_ATM_LOCATION s
    GROUP BY s.ATMId, s.LocationCode, s.Channel, s.SourceSystemName, s.LoadDts, s.Amount;
END;
