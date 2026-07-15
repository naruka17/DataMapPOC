=== FILE: sql/staging/procs/sp_Load_STG_ATM_TXN_FILE_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_ATM_TXN_FILE_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: ATM withdrawal fraud monitoring.
    -- Purpose: Load ATM withdrawal extracts from SOR_ATM_FILE into staging.
    -- Lineage: SOR_ATM_FILE -> staging proc -> STG_ATM_TXN.

    CREATE TABLE #SOR_ATM_TXN (
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

    -- Read from SOR_ATM_FILE.
    INSERT INTO #SOR_ATM_TXN (TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    VALUES
        ('ATM1001','ACC2001','ATM01','2026-07-01 09:10:00','18000','USD','ATM','DEVATM01','10.0.0.10','LOCATM01','0.74','N','SOR_ATM_FILE','2026-07-01','2026-07-01 09:20:00','RUN003');

    -- Write to staging table STG_ATM_TXN.
    INSERT INTO fraud_staging.STG_ATM_TXN (
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_ATM_TXN;
END;
