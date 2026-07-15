=== FILE: sql/staging/procs/sp_Load_STG_CARD_TXN_LS_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_CARD_TXN_LS_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Credit card fraud monitoring.
    -- Purpose: Load card transaction data from a linked-server SOR via SOR_CARD_LS into staging.
    -- Lineage: SOR_CARD_LS -> staging proc -> STG_CARD_DEVICE.

    CREATE TABLE #SOR_CARD_LS (
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

    -- Source: linked server SOR_CARD_LS.
    INSERT INTO #SOR_CARD_LS (TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    SELECT
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, GETDATE(), 'RUN007'
    FROM [SOR_SERVER].[SOR_DB].dbo.UpstreamCardTable;

    -- Write to staging table STG_CARD_DEVICE.
    INSERT INTO fraud_staging.STG_CARD_DEVICE (
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, CardId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_CARD_LS;
END;
