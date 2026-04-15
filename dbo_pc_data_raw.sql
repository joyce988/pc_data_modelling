SELECT [Continent]
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

  --droping table to add primary key(dim_location.
  DROP TABLE dim_location
  create table dim_location
 ( [locationID] INT IDENTITY(1,1) PRIMARY KEY,
  [continent][nvarchar](50) NOT NULL,
  [country_or_state][nvarchar](50) NOT NULL,
  [province_or_city] [nvarchar](100) NOT NULL)

  --INSERTING INFORMATION INTO DIM_LOCATION TABLE.

  INSERT INTO [pc_data_raw].[dbo].[dim_location](continent,country_or_state,province_or_city)
  SELECT DISTINCT continent,country_or_state,province_or_city
   FROM [pc_data_raw].[dbo].[pc_data_raw]
  
  SELECT* FROM
[pc_data_raw].[dbo].[dim_location]

--droping dim_customer and create it again, load data.

  DROP TABLE dim_customer
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

--DIM-PAYMENT
DROP TABLE dim_payment

CREATE TABLE dim_payment
([paymentID] INT IDENTITY(1,1) PRIMARY KEY,
[Payment_Method][nvarchar](50) NOT NULL)

INSERT INTO [pc_data_raw].[dbo].[dim_payment](payment_method)
SELECT DISTINCT payment_method
  FROM [pc_data_raw].[dbo].[pc_data_raw]

  SELECT*
  FROM [pc_data_raw].[dbo].[dim_payment]

--DIM_SALE TABLE
DROP TABLE dim_sale

CREATE TABLE dim_sale
([saleID] INT IDENTITY(1,1) PRIMARY KEY,
  [Sales_Person_Name][nvarchar](50) NOT NULL,
      [Sales_Person_Department][nvarchar](50) NOT NULL)
INSERT INTO [pc_data_raw].[dbo].[dim_sale](Sales_Person_Name,Sales_Person_Department)
SELECT DISTINCT Sales_Person_Name,Sales_Person_Department 
FROM  [pc_data_raw].[dbo].[pc_data_raw]

SELECT*
FROM [pc_data_raw].[dbo].[dim_sale]

--dim_storage
DROP TABLE dim_storage
CREATE TABLE dim_storage
([storageID] INT IDENTITY(1,1) PRIMARY KEY,
 [Storage_Type][nvarchar](50) NOT NULL,
      [RAM][nvarchar](50) NOT NULL,
      [Storage_Capacity][nvarchar](50))

INSERT INTO  [pc_data_raw].[dbo].[dim_storage](storage_type,RAM, storage_capacity)
SELECT DISTINCT storage_type,RAM,storage_capacity
FROM [pc_data_raw].[dbo].[pc_data_raw]

SELECT*
FROM [pc_data_raw].[dbo].[dim_storage]

--FACT TABLE
DROP TABLE fact_table
CREATE TABLE fact_table
([orderID] INT IDENTITY(1,1) PRIMARY KEY,
 [Cost_Price][nvarchar](50) NOT NULL,
      [Sale_Price][nvarchar](50) NOT NULL,
      [Discount_Amount][nvarchar](50) NOT NULL,
      [Finance_Amount][nvarchar](50) NOT NULL,
      [Cost_of_Repairs][nvarchar](50) NOT NULL,
      [PC_Market_Price][nvarchar](50) NOT NULL)

INSERT INTO  [pc_data_raw].[dbo].[fact_table](cost_price,sale_price,discount_amount,finance_amount,cost_of_repairs,pc_market_price)
SELECT DISTINCT cost_price,sale_price,discount_amount,finance_amount,cost_of_repairs,pc_market_price
FROM [pc_data_raw].[dbo].[pc_data_raw]

SELECT*
FROM [pc_data_raw].[dbo].[fact_table]

--inserting orderID into fact table.

DROP TABLE fact_table
CREATE TABLE fact_table
([orderID] INT IDENTITY(1,1) PRIMARY KEY,
[locationID] INT,
[customerID] INT,
[paymentID] INT,
[saleID] INT,
[storageID] INT,
 [Cost_Price][nvarchar](50) NOT NULL,
      [Sale_Price][nvarchar](50) NOT NULL,
      [Discount_Amount][nvarchar](50) NOT NULL,
      [Finance_Amount][nvarchar](50) NOT NULL,
      [Cost_of_Repairs][nvarchar](50) NOT NULL,
      [PC_Market_Price][nvarchar](50) NOT NULL
 CONSTRAINT fk_locationID
           foreign key(locationID)
    references [pc_data_raw].[dbo].[dim_location](locationID),

CONSTRAINT fk_customerID
foreign key(customerID)
references [pc_data_raw].[dbo].[dim_customer](customerID),


CONSTRAINT fk_paymentID
foreign key(paymentID)
references [pc_data_raw].[dbo].[dim_payment](paymentID),

CONSTRAINT fk_saleID
foreign key(saleID)
references [pc_data_raw].[dbo].[dim_sale](saleID),

CONSTRAINT fk_storageID
foreign key(storageID)
references [pc_data_raw].[dbo].[dim_storage](storageID),)

select*
from  [pc_data_raw].[dbo].[fact_table]

