=== FILE: sql/views/vw_ATM_Fraud_By_Device.sql ===

CREATE OR ALTER VIEW fraud.vw_ATM_Fraud_By_Device AS
SELECT
    f.DeviceId,
    d.DeviceRiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_ATM_FRAUD f
-- Join on ATMId and DeviceId to enrich with ATM profile.
JOIN fraud.DIM_ATM d ON d.ATMId = f.ATMId
GROUP BY f.DeviceId, d.DeviceRiskLevel;
