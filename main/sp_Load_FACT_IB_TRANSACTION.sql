=== FILE: sql/main/procs/sp_Load_FACT_IB_TRANSACTION.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_FACT_IB_TRANSACTION
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Internet banking fraud monitoring.
    -- Purpose: Create transaction-level facts from internet banking staging.
    -- Lineage: STG_IB_TXN + DIM_CHANNEL_DEVICE -> main proc -> FACT_IB_TRANSACTION.

    INSERT INTO fraud.FACT_IB_TRANSACTION (
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
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 12000 THEN 0.94 ELSE 0.66 END AS FraudScore,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 12000 THEN 'Y' ELSE 'N' END AS ConfirmedFraudFlag,
        'IBTXN-' + s.TxnId AS CaseId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 12000 THEN 'High' ELSE 'Medium' END AS RiskBand,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_IB_TXN s
    LEFT JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = s.DeviceId
    WHERE TRY_CAST(s.Amount AS DECIMAL(18,2)) > 800;
END;
