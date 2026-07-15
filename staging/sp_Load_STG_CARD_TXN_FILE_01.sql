=== FILE: sql/staging/procs/sp_Load_STG_CARD_TXN_FILE_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_CARD_TXN_FILE_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Credit card fraud monitoring.
    -- Purpose: Load daily card transaction extracts from SOR_CARD_FILE into the staging layer.
    -- Lineage: SOR_CARD_FILE -> staging proc -> STG_CARD_TXN.

    CREATE TABLE #SOR_CARD_TXN (
        TxnId NVARCHAR(50),
        CardId NVARCHAR(50),
        AccountId NVARCHAR(50),
        TxnTimestamp NVARCHAR(50),
        Amount NVARCHAR(50),
        CurrencyCode NVARCHAR(10),
        Channel NVARCHAR(30),
        DeviceId NVARCHAR(50),
        IPAddress NVARCHAR(50),
        LocationCode NVARCHAR(20),
        RiskScoreRaw NVARCHAR(20),
        FraudFlagRaw NVARCHAR(5),
        SourceSystemName NVARCHAR(50),
        SourceExtractTs NVARCHAR(50),
        LoadDts DATETIME,
        LoadRunId NVARCHAR(50)
    );

    -- Read from SOR_CARD_FILE.
    INSERT INTO #SOR_CARD_TXN (TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    VALUES
        ('TXN1001','CARD1001','ACC1001','2026-07-01 08:15:00','52000','USD','POS','DEV01','10.0.0.1','LOC01','0.85','N','SOR_CARD_FILE','2026-07-01','2026-07-01 09:00:00','RUN001');

    -- Write to staging table STG_CARD_TXN.
    INSERT INTO fraud_staging.STG_CARD_TXN (
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_CARD_TXN;
END;
