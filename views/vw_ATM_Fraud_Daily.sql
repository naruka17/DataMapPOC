=== FILE: sql/views/vw_ATM_Fraud_Daily.sql ===

CREATE OR ALTER VIEW fraud.vw_ATM_Fraud_Daily AS
SELECT
    CAST(f.TxnTimestamp AS DATE) AS FraudDate,
    f.ATMId,
    d.LocationCode,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore,
    MAX(CASE WHEN f.ConfirmedFraudFlag = 'Y' THEN 1 ELSE 0 END) AS HasConfirmedFraud
FROM fraud.FACT_ATM_FRAUD f
-- Join on ATMId to enrich transaction with ATM context.
JOIN fraud.DIM_ATM d ON d.ATMId = f.ATMId
GROUP BY CAST(f.TxnTimestamp AS DATE), f.ATMId, d.LocationCode;
