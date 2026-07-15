=== FILE: sql/views/vw_Card_Fraud_By_Device.sql ===

CREATE OR ALTER VIEW fraud.vw_Card_Fraud_By_Device AS
SELECT
    f.DeviceId,
    d.RiskLevel,
    COUNT(*) AS FraudTxnCount,
    SUM(f.Amount) AS FraudAmount,
    AVG(f.FraudScore) AS AvgFraudScore
FROM fraud.FACT_CARD_FRAUD f
-- Join on CardId and DeviceId to enrich with card profile.
JOIN fraud.DIM_CARD d ON d.CardId = f.CardId
GROUP BY f.DeviceId, d.RiskLevel;
