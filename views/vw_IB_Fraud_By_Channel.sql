=== FILE: sql/views/vw_IB_Fraud_By_Channel.sql ===

CREATE OR ALTER VIEW fraud.vw_IB_Fraud_By_Channel AS
SELECT
    f.Channel,
    d.DeviceRiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_IB_FRAUD f
-- Join on DeviceId to enrich transaction with channel risk profile.
JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = f.DeviceId
GROUP BY f.Channel, d.DeviceRiskLevel;
