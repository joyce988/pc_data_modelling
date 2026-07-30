-- Create stg_dim_payment table only if it does not exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = 'stg_dim_payment'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_payment]
    (
        [paymentID] INT IDENTITY(1,1) PRIMARY KEY,
        [Payment_Method] NVARCHAR(50) NOT NULL
    );

END;
GO

-- Insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_payment]
(
    Payment_Method
)
SELECT DISTINCT
    payment_method
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE payment_method IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_payment] p
    WHERE p.Payment_Method = stg.payment_method
);

-- View inserted data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_payment];
GO