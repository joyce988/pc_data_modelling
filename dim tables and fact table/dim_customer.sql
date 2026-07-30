  
CREATE TABLE dim_customer 
([customerID] INT IDENTITY(1,1) PRIMARY KEY,
 [Customer_Name][nvarchar](50) NOT NULL,
      [Customer_Surname][nvarchar](50) NOT NULL,
      [Customer_Contact_Number][nvarchar](50) NOT NULL,
      [Customer_Email_Address][nvarchar](50) NOT NULL)

      INSERT INTO [pc_data_raw].[dbo].[dim_customer](Customer_Name,Customer_Surname,Customer_Contact_Number,Customer_Email_Address)
SELECT DISTINCT Customer_Name,Customer_Surname,Customer_Contact_Number,Customer_Email_Address
 FROM [pc_data_raw].[dbo].[pc_data_raw]

  SELECT *
FROM [pc_data_raw].[dbo].[dim_customer]