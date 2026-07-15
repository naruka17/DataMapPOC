=== FILE: sql/views/vw_Merchant_Fraud_Daily.sql ===

CREATE OR ALTER VIEW fraud.vw_Merchant_Fraud_Daily AS
SELECT
    CAST(f.TxnTimestamp AS DATE) AS FraudDate,
    f.MerchantId,
    d.MerchantCategory,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore,
    MAX(CASE WHEN f.ConfirmedFraudFlag = 'Y' THEN 1 ELSE 0 END) AS HasConfirmedFraud
FROM fraud.FACT_MERCHANT_FRAUD f
-- Join on MerchantId to enrich transaction with merchant category.
JOIN fraud.DIM_MERCHANT d ON d.MerchantId = f.MerchantId
GROUP BY CAST(f.TxnTimestamp AS DATE), f.MerchantId, d.MerchantCategory;
