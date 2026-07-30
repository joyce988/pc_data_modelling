-- create stg_dim_priority only if it does not exist
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'stg_dim_priority'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_priority]
    (
        [priorityid] INT IDENTITY(1,1) PRIMARY KEY,
        [priority] NVARCHAR(50) NOT NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );

END;
GO

-- insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_priority]
(
    priority
)
SELECT DISTINCT
    priority
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE priority IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_priority] pr
    WHERE pr.priority = stg.priority
);

-- view data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_priority];
GO