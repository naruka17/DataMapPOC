=== FILE: sql/views/vw_Merchant_Fraud_By_Device.sql ===

CREATE OR ALTER VIEW fraud.vw_Merchant_Fraud_By_Device AS
SELECT
    f.DeviceId,
    d.DeviceRiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_MERCHANT_FRAUD f
-- Join on MerchantId to enrich transaction with merchant device risk.
JOIN fraud.DIM_MERCHANT d ON d.MerchantId = f.MerchantId
GROUP BY f.DeviceId, d.DeviceRiskLevel;
