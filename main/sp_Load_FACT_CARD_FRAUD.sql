=== FILE: sql/main/procs/sp_Load_FACT_CARD_FRAUD.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_FACT_CARD_FRAUD
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Credit card fraud monitoring.
    -- Purpose: Create fact-level card fraud records from staging and dimension inputs.
    -- Lineage: STG_CARD_TXN + DIM_CARD -> main proc -> FACT_CARD_FRAUD.

    INSERT INTO fraud.FACT_CARD_FRAUD (
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
        CASE
            WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 50000 THEN 0.92
            WHEN s.Channel = 'WEB' THEN 0.75
            ELSE 0.55
        END AS FraudScore,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 50000 THEN 'Y' ELSE 'N' END AS ConfirmedFraudFlag,
        'CASE-' + s.TxnId AS CaseId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 50000 THEN 'High' ELSE 'Medium' END AS RiskBand,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_CARD_TXN s
    -- Join on CardId to attach customer segment.
    LEFT JOIN fraud.DIM_CARD d ON d.CardId = s.CardId
    WHERE TRY_CAST(s.Amount AS DECIMAL(18,2)) > 1000;
END;
