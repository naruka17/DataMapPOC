=== FILE: sql/views/vw_IB_Fraud_By_Device.sql ===

CREATE OR ALTER VIEW fraud.vw_IB_Fraud_By_Device AS
SELECT
    f.DeviceId,
    d.DeviceRiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_IB_FRAUD f
-- Join on DeviceId to enrich transaction with device risk level.
JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = f.DeviceId
GROUP BY f.DeviceId, d.DeviceRiskLevel;
