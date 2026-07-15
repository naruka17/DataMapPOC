=== FILE: sql/views/vw_Card_Fraud_By_Channel.sql ===

CREATE OR ALTER VIEW fraud.vw_Card_Fraud_By_Channel AS
SELECT
    f.Channel,
    d.RiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore,
    MAX(CASE WHEN f.ConfirmedFraudFlag = 'Y' THEN 1 ELSE 0 END) AS HasConfirmedFraud
FROM fraud.FACT_CARD_FRAUD f
-- Join on CardId and Channel to enrich with card risk profile.
JOIN fraud.DIM_CARD d ON d.CardId = f.CardId
GROUP BY f.Channel, d.RiskLevel;
