=== FILE: sql/views/vw_Merchant_Fraud_By_Category.sql ===

CREATE OR ALTER VIEW fraud.vw_Merchant_Fraud_By_Category AS
SELECT
    d.MerchantCategory,
    f.Channel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_MERCHANT_FRAUD f
-- Join on MerchantId to enrich transaction with merchant category.
JOIN fraud.DIM_MERCHANT d ON d.MerchantId = f.MerchantId
GROUP BY d.MerchantCategory, f.Channel;
