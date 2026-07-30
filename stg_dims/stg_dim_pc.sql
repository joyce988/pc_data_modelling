-- create stg_dim_pc only if it does not exist
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'stg_dim_pc'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_pc]
    (
        [pcid] INT IDENTITY(1,1) PRIMARY KEY,
        [pc_make] NVARCHAR(50) NOT NULL,
        [pc_model] NVARCHAR(50) NOT NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );

END;
GO

-- insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_pc]
(
    pc_make,
    pc_model
)
SELECT DISTINCT
    pc_make,
    pc_model
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE pc_make IS NOT NULL
AND pc_model IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_pc] pc
    WHERE pc.pc_make = stg.pc_make
      AND pc.pc_model = stg.pc_model
);

-- view data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_pc];
GO