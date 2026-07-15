=== FILE: sql/views/vw_Card_Fraud_Daily.sql ===

CREATE OR ALTER VIEW fraud.vw_Card_Fraud_Daily AS
SELECT
    CAST(f.TxnTimestamp AS DATE) AS FraudDate,
    f.CardId,
    d.CustomerSegment,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore,
    MAX(CASE WHEN f.ConfirmedFraudFlag = 'Y' THEN 1 ELSE 0 END) AS HasConfirmedFraud
FROM fraud.FACT_CARD_FRAUD f
-- Join on CardId to enrich transaction with customer segment.
JOIN fraud.DIM_CARD d ON d.CardId = f.CardId
GROUP BY CAST(f.TxnTimestamp AS DATE), f.CardId, d.CustomerSegment;
