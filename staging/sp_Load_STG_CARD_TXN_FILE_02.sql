=== FILE: sql/staging/procs/sp_Load_STG_CARD_TXN_FILE_02.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_CARD_TXN_FILE_02
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Credit card fraud monitoring.
    -- Purpose: Load evening card transaction extracts from SOR_CARD_FILE into staging.
    -- Lineage: SOR_CARD_FILE -> staging proc -> STG_CARD_ALERT.

    CREATE TABLE #SOR_CARD_ALERT (
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
    INSERT INTO #SOR_CARD_ALERT (TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    VALUES
        ('TXN1002','CARD1002','ACC1002','2026-07-01 20:40:00','62000','USD','WEB','DEV02','10.0.0.2','LOC02','0.87','N','SOR_CARD_FILE','2026-07-01','2026-07-01 20:50:00','RUN002');

    -- Write to staging table STG_CARD_ALERT.
    INSERT INTO fraud_staging.STG_CARD_ALERT (
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_CARD_ALERT;
END;
