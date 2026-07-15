=== FILE: sql/staging/procs/sp_Load_STG_ATM_TXN_FILE_02.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_ATM_TXN_FILE_02
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: ATM withdrawal fraud monitoring.
    -- Purpose: Load ATM location extracts from SOR_ATM_FILE into staging.
    -- Lineage: SOR_ATM_FILE -> staging proc -> STG_ATM_LOCATION.

    CREATE TABLE #SOR_ATM_LOC (
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
    INSERT INTO #SOR_ATM_LOC (TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    VALUES
        ('ATM1002','ACC2002','ATM02','2026-07-01 11:30:00','24000','USD','ATM','DEVATM02','10.0.0.11','LOCATM02','0.79','N','SOR_ATM_FILE','2026-07-01','2026-07-01 11:40:00','RUN004');

    -- Write to staging table STG_ATM_LOCATION.
    INSERT INTO fraud_staging.STG_ATM_LOCATION (
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, AccountId, ATMId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_ATM_LOC;
END;
