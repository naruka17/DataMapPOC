=== FILE: sql/staging/procs/sp_Load_STG_MERCHANT_TXN_FILE_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_MERCHANT_TXN_FILE_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Merchant / POS transaction fraud.
    -- Purpose: Load merchant transaction feed from SOR_MERCHANT_FILE into staging.
    -- Lineage: SOR_MERCHANT_FILE -> staging proc -> STG_MERCHANT_TXN.

    CREATE TABLE #SOR_MERCHANT_TXN (
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

    -- Read from SOR_MERCHANT_FILE.
    INSERT INTO #SOR_MERCHANT_TXN (TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    VALUES
        ('POS1001','MER1001','CUST4001','2026-07-01 13:05:00','7800','USD','POS','POSDEV01','10.0.0.40','LOCPOS01','0.86','N','SOR_MERCHANT_FILE','2026-07-01','2026-07-01 13:10:00','RUN006');

    -- Write to staging table STG_MERCHANT_TXN.
    INSERT INTO fraud_staging.STG_MERCHANT_TXN (
        TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, MerchantId, CustomerId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_MERCHANT_TXN;
END;
