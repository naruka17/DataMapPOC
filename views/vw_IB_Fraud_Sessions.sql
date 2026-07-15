=== FILE: sql/views/vw_IB_Fraud_Sessions.sql ===

CREATE OR ALTER VIEW fraud.vw_IB_Fraud_Sessions AS
SELECT
    CAST(f.TxnTimestamp AS DATE) AS FraudDate,
    f.CustomerId,
    d.ChannelType,
    COUNT(*) AS FraudSessionCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore,
    MAX(CASE WHEN f.ConfirmedFraudFlag = 'Y' THEN 1 ELSE 0 END) AS HasConfirmedFraud
FROM fraud.FACT_IB_FRAUD f
-- Join on DeviceId and Channel to enrich transaction with device profile.
JOIN fraud.DIM_CHANNEL_DEVICE d ON d.DeviceId = f.DeviceId
GROUP BY CAST(f.TxnTimestamp AS DATE), f.CustomerId, d.ChannelType;
