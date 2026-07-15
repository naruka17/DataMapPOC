=== FILE: sql/views/vw_IB_Fraud_By_Customer.sql ===

CREATE OR ALTER VIEW fraud.vw_IB_Fraud_By_Customer AS
SELECT
    f.CustomerId,
    d.ChannelType,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_IB_FRAUD f
-- Join on DeviceId to enrich customer profile with device dimension.
JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = f.DeviceId
GROUP BY f.CustomerId, d.ChannelType;
