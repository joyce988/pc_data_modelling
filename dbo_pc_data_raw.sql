SELECT TOP (1000) [Continent]
      ,[Country_or_State]
      ,[Province_or_City]
      ,[Shop_Name]
      ,[Shop_Age]
      ,[PC_Make]
      ,[PC_Model]
      ,[Storage_Type]
      ,[Customer_Name]
      ,[Customer_Surname]
      ,[Customer_Contact_Number]
      ,[Customer_Email_Address]
      ,[Sales_Person_Name]
      ,[Sales_Person_Department]
      ,[Cost_Price]
      ,[Sale_Price]
      ,[Payment_Method]
      ,[Discount_Amount]
      ,[Purchase_Date]
      ,[Ship_Date]
      ,[Finance_Amount]
      ,[RAM]
      ,[Credit_Score]
      ,[Channel]
      ,[Priority]
      ,[Cost_of_Repairs]
      ,[Total_Sales_per_Employee]
      ,[PC_Market_Price]
      ,[Storage_Capacity]
  FROM [pc_data_raw].[dbo].[pc_data_raw]
  
  SELECT [Customer_Name]
      ,[Customer_Surname]
      ,[Customer_Contact_Number]
      ,[Customer_Email_Address]
  FROM [pc_data_raw].[dbo].[dim_customer]

  select distinct
  [Customer_Name]
      ,[Customer_Surname]
      ,[Customer_Contact_Number]
      ,[Customer_Email_Address]
  FROM [pc_data_raw].[dbo].[dim_customer]

  SELECT  [Continent]
      ,[Country_or_State]
      ,[Province_or_City]
  FROM [pc_data_raw].[dbo].[dim_location]

  --cleaning joins and see unigue combination from selected columns

  select distinct
  [Continent]
      ,[Country_or_State]
      ,[Province_or_City]
FROM [pc_data_raw].[dbo].[dim_location]

SELECT  [Payment_Method]
  FROM [pc_data_raw].[dbo].[dim_payment]

  select distinct
   [Payment_Method]
  FROM [pc_data_raw].[dbo].[dim_payment]

  SELECT  [Sales_Person_Name]
      ,[Sales_Person_Department]
  FROM [pc_data_raw].[dbo].[dim_sale]

 SELECT distinct
 [Sales_Person_Name]
      ,[Sales_Person_Department]
  FROM [pc_data_raw].[dbo].[dim_sale]

  SELECT [Storage_Type]
      ,[RAM]
      ,[Storage_Capacity]
  FROM [pc_data_raw].[dbo].[dim_storage]

  select distinct
   [Storage_Type]
      ,[RAM]
      ,[Storage_Capacity]
  FROM [pc_data_raw].[dbo].[dim_storage]

  SELECT [Cost_Price]
      ,[Sale_Price]
      ,[Discount_Amount]
      ,[Finance_Amount]
      ,[Cost_of_Repairs]
      ,[PC_Market_Price]
  FROM [pc_data_raw].[dbo].[fact_table]

  select distinct
   [Cost_Price]
      ,[Sale_Price]
      ,[Discount_Amount]
      ,[Finance_Amount]
      ,[Cost_of_Repairs]
      ,[PC_Market_Price]
  FROM [pc_data_raw].[dbo].[fact_table]






