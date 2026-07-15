=== FILE: sql/staging/procs/sp_Load_STG_MERCHANT_TXN_LS_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_MERCHANT_TXN_LS_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Merchant / POS transaction fraud.
    -- Purpose: Load merchant transaction data from linked-server SOR_MERCHANT_LS into staging.
    -- Lineage: SOR_MERCHANT_LS -> staging proc -> STG_MERCHANT_DEVICE.

    CREATE TABLE #SOR_MERCHANT_LS (
        TxnId NVARCHAR(50),
        MerchantId NVARCHAR(50),
        CustomerId NVARCHAR(50),
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

    -- Source: linked server SOR_MERCHANT_LS.
    INSERT INTO #SOR_MERCHANT_LS (TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    SELECT
        TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, GETDATE(), 'RUN010'
    FROM [SOR_SERVER].[SOR_DB].dbo.UpstreamMerchantTable;

    -- Write to staging table STG_MERCHANT_DEVICE.
    INSERT INTO fraud_staging.STG_MERCHANT_DEVICE (
        TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_MERCHANT_LS;
END;
