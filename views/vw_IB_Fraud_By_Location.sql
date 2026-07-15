=== FILE: sql/views/vw_IB_Fraud_By_Location.sql ===

CREATE OR ALTER VIEW fraud.vw_IB_Fraud_By_Location AS
SELECT
    f.LocationCode,
    d.ChannelType,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_IB_FRAUD f
-- Join on DeviceId and LocationCode to enrich with device channel context.
JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = f.DeviceId
GROUP BY f.LocationCode, d.ChannelType;
