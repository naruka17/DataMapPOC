=== FILE: sql/views/vw_Card_Fraud_By_Customer.sql ===

CREATE OR ALTER VIEW fraud.vw_Card_Fraud_By_Customer AS
SELECT
    f.CardId,
    d.CustomerSegment,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_CARD_FRAUD f
-- Join on CardId to enrich transaction with customer segment.
JOIN fraud.DIM_CARD d ON d.CardId = f.CardId
GROUP BY f.CardId, d.CustomerSegment;
