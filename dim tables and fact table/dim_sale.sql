CREATE TABLE dim_sale
([saleID] INT IDENTITY(1,1) PRIMARY KEY,
  [Sales_Person_Name][nvarchar](50) NOT NULL,
      [Sales_Person_Department][nvarchar](50) NOT NULL)

      INSERT INTO [pc_data_raw].[dbo].[dim_sale](Sales_Person_Name,Sales_Person_Department)
SELECT DISTINCT Sales_Person_Name,Sales_Person_Department 
FROM  [pc_data_raw].[dbo].[pc_data_raw]

SELECT*
FROM [pc_data_raw].[dbo].[dim_sale]
