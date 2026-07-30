-- create stg_dim_storage only if it does not exist
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'stg_dim_storage'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_storage]
    (
        [storageid] INT IDENTITY(1,1) PRIMARY KEY,
        [storage_type] NVARCHAR(50) NOT NULL,
        [ram] NVARCHAR(50) NOT NULL,
        [storage_capacity] NVARCHAR(50) NULL
    );

END;
GO

-- insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_storage]
(
    storage_type,
    ram,
    storage_capacity
)
SELECT DISTINCT
    storage_type,
    ram,
    storage_capacity
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE storage_type IS NOT NULL
AND ram IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_storage] st
    WHERE st.storage_type = stg.storage_type
      AND st.ram = stg.ram
      AND ISNULL(st.storage_capacity,'') = ISNULL(stg.storage_capacity,'')
);

-- view data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_storage];
GO