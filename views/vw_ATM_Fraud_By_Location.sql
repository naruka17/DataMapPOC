=== FILE: sql/views/vw_ATM_Fraud_By_Location.sql ===

CREATE OR ALTER VIEW fraud.vw_ATM_Fraud_By_Location AS
SELECT
    f.LocationCode,
    d.DeviceRiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_ATM_FRAUD f
-- Join on ATMId and LocationCode to enrich with ATM risk.
JOIN fraud.DIM_ATM d ON d.ATMId = f.ATMId
GROUP BY f.LocationCode, d.DeviceRiskLevel;
