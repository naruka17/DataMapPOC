=== FILE: sql/views/vw_ATM_Fraud_By_Hour.sql ===

CREATE OR ALTER VIEW fraud.vw_ATM_Fraud_By_Hour AS
SELECT
    DATEPART(HOUR, f.TxnTimestamp) AS FraudHour,
    d.LocationCode,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_ATM_FRAUD f
-- Join on ATMId to enrich transaction with location context.
JOIN fraud.DIM_ATM d ON d.ATMId = f.ATMId
GROUP BY DATEPART(HOUR, f.TxnTimestamp), d.LocationCode;
