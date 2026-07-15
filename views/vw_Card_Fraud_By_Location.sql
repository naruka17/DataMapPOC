=== FILE: sql/views/vw_Card_Fraud_By_Location.sql ===

CREATE OR ALTER VIEW fraud.vw_Card_Fraud_By_Location AS
SELECT
    f.LocationCode,
    d.CustomerSegment,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_CARD_FRAUD f
-- Join on CardId and LocationCode to enrich with card context.
JOIN fraud.DIM_CARD d ON d.CardId = f.CardId
GROUP BY f.LocationCode, d.CustomerSegment;
