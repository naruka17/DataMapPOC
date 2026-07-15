=== FILE: sql/main/procs/sp_Load_FACT_MERCHANT_FRAUD.sql ===

CREATE OR ALTER PROCEDURE fraud.sp_Load_FACT_MERCHANT_FRAUD
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Merchant / POS transaction fraud.
    -- Purpose: Create merchant fraud facts from POS staging data.
    -- Lineage: STG_MERCHANT_TXN + DIM_MERCHANT -> main proc -> FACT_MERCHANT_FRAUD.

    INSERT INTO fraud.FACT_MERCHANT_FRAUD (
        TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, LocationCode,
        FraudScore, ConfirmedFraudFlag, CaseId, RiskBand, SourceSystemName, LoadDts
    )
    SELECT
        s.TxnId,
        s.MerchantId,
        s.CustomerId,
        s.TxnTimestamp,
        TRY_CAST(s.Amount AS DECIMAL(18,2)) AS Amount,
        s.CurrencyCode,
        s.Channel,
        s.DeviceId,
        s.LocationCode,
        CASE
            WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 7000 THEN 0.89
            WHEN s.Channel = 'POS' THEN 0.70
            ELSE 0.58
        END AS FraudScore,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 7000 THEN 'Y' ELSE 'N' END AS ConfirmedFraudFlag,
        'POSCASE-' + s.TxnId AS CaseId,
        CASE WHEN TRY_CAST(s.Amount AS DECIMAL(18,2)) > 7000 THEN 'High' ELSE 'Medium' END AS RiskBand,
        s.SourceSystemName,
        s.LoadDts
    FROM fraud_staging.STG_MERCHANT_TXN s
    -- Join on MerchantId to attach merchant category.
    LEFT JOIN fraud.DIM_MERCHANT d ON d.MerchantId = s.MerchantId
    WHERE TRY_CAST(s.Amount AS DECIMAL(18,2)) > 1000;
END;
