=== FILE: sql/staging/procs/sp_Load_STG_IB_SESSION_FILE_01.sql ===

CREATE OR ALTER PROCEDURE fraud_staging.sp_Load_STG_IB_SESSION_FILE_01
AS
BEGIN
    SET NOCOUNT ON;

    -- Domain: Internet banking fraud monitoring.
    -- Purpose: Load internet banking session extracts from SOR_IB_FILE into staging.
    -- Lineage: SOR_IB_FILE -> staging proc -> STG_IB_SESSION.

    CREATE TABLE #SOR_IB_SESSION (
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

    -- Read from SOR_IB_FILE.
    INSERT INTO #SOR_IB_SESSION (TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode, RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId)
    VALUES
        ('IB1001','CUST3001','ACC3001','2026-07-01 09:45:00','1500','USD','WEB','DEVIB01','10.0.0.30','LOCIB01','0.81','N','SOR_IB_FILE','2026-07-01','2026-07-01 09:55:00','RUN005');

    -- Write to staging table STG_IB_SESSION.
    INSERT INTO fraud_staging.STG_IB_SESSION (
        TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    )
    SELECT
        TxnId, CustomerId, AccountId, TxnTimestamp, Amount, CurrencyCode, Channel, DeviceId, IPAddress, LocationCode,
        RiskScoreRaw, FraudFlagRaw, SourceSystemName, SourceExtractTs, LoadDts, LoadRunId
    FROM #SOR_IB_SESSION;
END;
