=== FILE: sql/main/procs/sp_Load_FACT_ATM_FRAUD.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_FACT_ATM_FRAUD
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: ATM withdrawal fraud monitoring.
    -- Purpose: Derive ATM fraud fact rows from staging and location dimensions.
    -- Lineage: STG_ATM_TXN + STG_ATM_LOCATION + DIM_ATM -> main proc -> FACT_ATM_FRAUD.

    INSERT INTO fraud.FACT_ATM_FRAUD (
        TxnId, ATMId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, LocationCode,
        FraudScore, ConfirmedFraudFlag, CaseId, RiskBand, SourceSystemName, LoadDts
    )
    SELECT
        s.TxnId,
        s.ATMId,
        s.AccountId,
        s.TxnTimestamp,
        TRY_CAST(s.Amount AS DECIMAL(18,2)) AS Amount,
        s.CurrencyCode,
        s.Channel,
        s.DeviceId,
        s.LocationCode,
        CASE
            WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 15000 THEN 0.90
            WHEN s.LocationCode LIKE 'LOCATM%' THEN 0.72
            ELSE 0.60
        END AS FraudScore,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 15000 THEN 'Y' ELSE 'N' END AS ConfirmedFraudFlag,
        'ATMCASE-' + s.TxnId AS CaseId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 15000 THEN 'High' ELSE 'Medium' END AS RiskBand,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_ATM_TXN s
    -- Join on ATMId to attach ATM context.
    LEFT JOIN fraud.DIM_ATM d ON d.ATMId = s.ATMId
    WHERE TRY_CAST(s.Amount AS DECIMAL(18,2)) > 1000;
END;
