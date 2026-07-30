-- create stg_dim_shop only if it does not exist
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'stg_dim_shop'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_shop]
    (
        [shopid] INT IDENTITY(1,1) PRIMARY KEY,
        [shop_name] NVARCHAR(50) NOT NULL,
        [shop_age] NVARCHAR(50) NOT NULL,
        [load_date] DATETIME DEFAULT GETDATE()
    );

END;
GO

-- insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_shop]
(
    shop_name,
    shop_age
)
SELECT DISTINCT
    shop_name,
    shop_age
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE shop_name IS NOT NULL
AND shop_age IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_shop] sh
    WHERE sh.shop_name = stg.shop_name
      AND sh.shop_age = stg.shop_age
);

-- view data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_shop];
GO