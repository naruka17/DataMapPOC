=== FILE: sql/main/procs/sp_Load_FACT_CARD_ALERT.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_FACT_CARD_ALERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Credit card fraud monitoring.
    -- Purpose: Create alert fact records from card alert staging.
    -- Lineage: STG_CARD_ALERT + DIM_CARD -> main proc -> FACT_CARD_ALERT.

    INSERT INTO fraud.FACT_CARD_ALERT (
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, LocationCode,
        FraudScore, ConfirmedFraudFlag, CaseId, RiskBand, SourceSystemName, LoadDts
    )
    SELECT
        s.TxnId,
        s.CardId,
        s.AccountId,
        s.TxnTimestamp,
        TRY_CAST(s.Amount AS DECIMAL(18,2)) AS Amount,
        s.CurrencyCode,
        s.Channel,
        s.DeviceId,
        s.LocationCode,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 60000 THEN 0.95 ELSE 0.68 END AS FraudScore,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 60000 THEN 'Y' ELSE 'N' END AS ConfirmedFraudFlag,
        'ALERT-' + s.TxnId AS CaseId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 60000 THEN 'High' ELSE 'Medium' END AS RiskBand,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_CARD_ALERT s
    -- Join on CardId to attach card profile.
    LEFT JOIN fraud.DIM_CARD d ON d.CardId = s.CardId
    WHERE TRY_CAST(s.Amount AS DECIMAL(18,2)) > 2000;
END;
