=== FILE: sql/staging/procs/sp_Load_STG_ATM_TXN_LS_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_ATM_TXN_LS_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: ATM withdrawal fraud monitoring.
    -- Purpose: Load ATM transaction data from linked-server SOR_ATM_LS into staging.
    -- Lineage: SOR_ATM_LS -> staging proc -> STG_ATM_DEVICE.

    CREATE TABLE #SOR_ATM_LS (
        TxnId NVARCHAR(50),
        AccountId NVARCHAR(50),
        ATMId NVARCHAR(50),
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

    -- Source: linked server SOR_ATM_LS.
    INSERT INTO #SOR_ATM_LS (TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    SELECT
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, GETDATE(), 'RUN008'
    FROM [SOR_SERVER].[SOR_DB].dbo.UpstreamAtmTable;

    -- Write to staging table STG_ATM_DEVICE.
    INSERT INTO fraud_staging.STG_ATM_DEVICE (
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_ATM_LS;
END;
