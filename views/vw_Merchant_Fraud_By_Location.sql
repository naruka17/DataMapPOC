=== FILE: sql/views/vw_Merchant_Fraud_By_Location.sql ===

CREATE OR ALTER VIEW fraud.vw_Merchant_Fraud_By_Location AS
SELECT
    f.LocationCode,
    d.MerchantCategory,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_MERCHANT_FRAUD f
-- Join on MerchantId and LocationCode to enrich with merchant context.
JOIN fraud.DIM_MERCHANT d ON d.MerchantId = f.MerchantId
GROUP BY f.LocationCode, d.MerchantCategory;
