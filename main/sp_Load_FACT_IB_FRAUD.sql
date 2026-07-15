=== FILE: sql/main/procs/sp_Load_FACT_IB_FRAUD.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_FACT_IB_FRAUD
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Internet banking fraud monitoring.
    -- Purpose: Create internet-banking fraud facts from session staging.
    -- Lineage: STG_IB_SESSION + DIM_CHANNEL_DEVICE -> main proc -> FACT_IB_FRAUD.

    INSERT INTO fraud.FACT_IB_FRAUD (
        TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, LocationCode,
        FraudScore, ConfirmedFraudFlag, CaseId, RiskBand, SourceSystemName, LoadDts
    )
    SELECT
        s.TxnId,
        s.CustomerId,
        s.AccountId,
        s.TxnTimestamp,
        TRY_CAST(s.Amount AS DECIMAL(18,2)) AS Amount,
        s.CurrencyCode,
        s.Channel,
        s.DeviceId,
        s.LocationCode,
        CASE
            WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 10000 THEN 0.91
            WHEN s.Channel = 'WEB' THEN 0.78
            ELSE 0.63
        END AS FraudScore,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 10000 THEN 'Y' ELSE 'N' END AS ConfirmedFraudFlag,
        'IBCASE-' + s.TxnId AS CaseId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 10000 THEN 'High' ELSE 'Medium' END AS RiskBand,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_IB_SESSION s
    -- Join on DeviceId to attach channel and device risk context.
    LEFT JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = s.DeviceId
    WHERE TRY_CAST(s.Amount AS DECIMAL(18,2)) > 500;
END;
