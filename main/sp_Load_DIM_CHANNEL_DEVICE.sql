=== FILE: sql/main/procs/sp_Load_DIM_CHANNEL_DEVICE.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_DIM_CHANNEL_DEVICE
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Internet banking fraud monitoring.
    -- Purpose: Build a channel-device dimension for internet banking fraud analysis.
    -- Lineage: STG_IB_TXN -> main proc -> DIM_CHANNEL_DEVICE.

    INSERT INTO fraud.DIM_CHANNEL_DEVICE (
        DeviceId, ChannelType, DeviceRiskLevel, LocationCode, SourceSystemName, LoadDts
    )
    SELECT
        s.DeviceId,
        s.Channel AS ChannelType,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 10000 THEN 'High' ELSE 'Medium' END AS DeviceRiskLevel,
        s.LocationCode,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_IB_TXN s
    GROUP BY s.DeviceId, s.Channel, s.LocationCode, s.SourceSystemName, s.LoadDts, s.Amount;
END;
