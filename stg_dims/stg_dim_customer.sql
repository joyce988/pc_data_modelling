IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = 'stg_dim_customer'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_customer]
    (
        [customerID] INT IDENTITY(1,1) PRIMARY KEY,
        [Customer_Name] NVARCHAR(50) NOT NULL,
        [Customer_Surname] NVARCHAR(50) NOT NULL,
        [Customer_Contact_Number] NVARCHAR(50) NOT NULL,
        [Customer_Email_Address] NVARCHAR(50) NOT NULL
    );

END;
GO

INSERT INTO [pc_data_staging].[dbo].[stg_dim_customer]
(
    Customer_Name,
    Customer_Surname,
    Customer_Contact_Number,
    Customer_Email_Address
)
SELECT DISTINCT
    Customer_Name,
    Customer_Surname,
    Customer_Contact_Number,
    Customer_Email_Address
FROM [pc_data_staging].[dbo].[pc_data_raw] stg
WHERE NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_customer] c
    WHERE c.Customer_Name = stg.Customer_Name
      AND c.Customer_Surname = stg.Customer_Surname
      AND c.Customer_Contact_Number = stg.Customer_Contact_Number
      AND c.Customer_Email_Address = stg.Customer_Email_Address
);

-- View data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_customer];
GO