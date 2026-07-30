-- Create table only if it does not exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = 'stg_dim_date'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_date]
    (
        [dateID] INT IDENTITY(1,1) PRIMARY KEY,
        [Purchase_Date] DATETIME2(7) NOT NULL,
        [Ship_Date] DATE NOT NULL,
        [Load_date] DATETIME DEFAULT GETDATE()
    );

END;
GO

-- Insert data
INSERT INTO [pc_data_staging].[dbo].[stg_dim_date]
(
    Purchase_Date,
    Ship_Date
)
SELECT DISTINCT
    TRY_CAST(Purchase_Date AS DATETIME2(7)),
    
    -- Replace NULL ship dates with 1999-12-31
    COALESCE(
        TRY_CAST(Ship_Date AS DATE),
        '1999-12-31'
    ) AS Ship_Date

FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE TRY_CAST(Purchase_Date AS DATETIME2(7)) IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_date] d
    WHERE d.Purchase_Date = TRY_CAST(stg.Purchase_Date AS DATETIME2(7))
    
    AND d.Ship_Date = COALESCE(
        TRY_CAST(stg.Ship_Date AS DATE),
        '1999-12-31'
    )
);

-- View data

SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_date];
GO