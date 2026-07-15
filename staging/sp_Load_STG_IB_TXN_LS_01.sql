=== FILE: sql/staging/procs/sp_Load_STG_IB_TXN_LS_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_IB_TXN_LS_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Internet banking fraud monitoring.
    -- Purpose: Load internet banking transaction data from linked-server SOR_IB_LS into staging.
    -- Lineage: SOR_IB_LS -> staging proc -> STG_IB_TXN.

    CREATE TABLE #SOR_IB_LS (
        TxnId NVARCHAR(50),
        CustomerId NVARCHAR(50),
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

    -- Source: linked server SOR_IB_LS.
    INSERT INTO #SOR_IB_LS (TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    SELECT
        TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, GETDATE(), 'RUN009'
    FROM [SOR_SERVER].[SOR_DB].dbo.UpstreamIbTable;

    -- Write to staging table STG_IB_TXN.
    INSERT INTO fraud_staging.STG_IB_TXN (
        TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_IB_LS;
END;
