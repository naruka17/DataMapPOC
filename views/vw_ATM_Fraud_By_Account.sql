=== FILE: sql/views/vw_ATM_Fraud_By_Account.sql ===

CREATE OR ALTER VIEW fraud.vw_ATM_Fraud_By_Account AS
SELECT
    f.AccountId,
    d.DeviceRiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_ATM_FRAUD f
-- Join on ATMId to enrich account context with ATM dimension.
JOIN fraud.DIM_ATM d ON d.ATMId = f.ATMId
GROUP BY f.AccountId, d.DeviceRiskLevel;
