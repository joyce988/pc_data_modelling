-- create stg_dim_sale only if it does not exist
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'stg_dim_sale'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_sale]
    (
        [saleid] INT IDENTITY(1,1) PRIMARY KEY,
        [sales_person_name] NVARCHAR(50) NOT NULL,
        [sales_person_department] NVARCHAR(50) NOT NULL
    );

END;
GO

-- insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_sale]
(
    sales_person_name,
    sales_person_department
)
SELECT DISTINCT
    sales_person_name,
    sales_person_department
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE sales_person_name IS NOT NULL
AND sales_person_department IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_sale] s
    WHERE s.sales_person_name = stg.sales_person_name
      AND s.sales_person_department = stg.sales_person_department
);

-- view data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_sale];
GO