--========================================
-- DROP FACT TABLE IF EXISTS
--========================================

IF OBJECT_ID('[pc_data_raw].[dbo].[fact_table]', 'U') IS NOT NULL
DROP TABLE [pc_data_raw].[dbo].[fact_table];
GO


--========================================
-- CREATE FACT TABLE
--========================================

CREATE TABLE [pc_data_raw].[dbo].[fact_table]
(
    [orderID] INT IDENTITY(1,1) PRIMARY KEY,

    [locationID] INT,
    [customerID] INT,
    [paymentID] INT,
    [saleID] INT,
    [storageID] INT,
    [priorityID] INT,
    [channelID] INT,
    [dateID] INT,
    [pcID] INT,
    [shopID] INT,

    [Cost_Price] INT NULL,
    [Sale_Price] INT NULL,
    [Discount_Amount] INT NULL,

    [Finance_Amount] DECIMAL(18,2) NULL,
    [Cost_of_Repairs] DECIMAL(18,2) NULL,

    [PC_Market_Price] INT NULL,
    [Credit_Score] INT NULL,
    [Total_Sales_per_Employee] INT NULL,

    [Load_date] DATETIME DEFAULT GETDATE(),

    --========================================
    -- FOREIGN KEYS
    --========================================

    CONSTRAINT fk_locationID
    FOREIGN KEY(locationID)
    REFERENCES [pc_data_raw].[dbo].[dim_location](locationID),

    CONSTRAINT fk_customerID
    FOREIGN KEY(customerID)
    REFERENCES [pc_data_raw].[dbo].[dim_customer](customerID),

    CONSTRAINT fk_paymentID
    FOREIGN KEY(paymentID)
    REFERENCES [pc_data_raw].[dbo].[dim_payment](paymentID),

    CONSTRAINT fk_saleID
    FOREIGN KEY(saleID)
    REFERENCES [pc_data_raw].[dbo].[dim_sale](saleID),

    CONSTRAINT fk_storageID
    FOREIGN KEY(storageID)
    REFERENCES [pc_data_raw].[dbo].[dim_storage](storageID),

    CONSTRAINT fk_priorityID
    FOREIGN KEY(priorityID)
    REFERENCES [pc_data_raw].[dbo].[dim_priority](priorityID),

    CONSTRAINT fk_channelID
    FOREIGN KEY(channelID)
    REFERENCES [pc_data_raw].[dbo].[dim_channel](channelID),

    CONSTRAINT fk_dateID
    FOREIGN KEY(dateID)
    REFERENCES [pc_data_raw].[dbo].[dim_date](dateID),

    CONSTRAINT fk_pcID
    FOREIGN KEY(pcID)
    REFERENCES [pc_data_raw].[dbo].[dim_pc](pcID),

    CONSTRAINT fk_shopID
    FOREIGN KEY(shopID)
    REFERENCES [pc_data_raw].[dbo].[dim_shop](shopID)
);

GO


--========================================
-- INSERT DATA INTO FACT TABLE
--========================================

INSERT INTO [pc_data_raw].[dbo].[fact_table]
(
    locationID,
    customerID,
    paymentID,
    saleID,
    storageID,
    priorityID,
    channelID,
    dateID,
    pcID,
    shopID,

    Cost_Price,
    Sale_Price,
    Discount_Amount,
    Finance_Amount,
    Cost_of_Repairs,
    PC_Market_Price,
    Credit_Score,
    Total_Sales_per_Employee
)

SELECT DISTINCT

    loc.locationID,
    cust.customerID,
    pay.paymentID,
    sal.saleID,
    sto.storageID,
    pr.priorityID,
    cha.channelID,
    dat.dateID,
    pc.pcID,
    sho.shopID,

    TRY_CAST(stg.Cost_Price AS INT) AS Cost_Price,
    TRY_CAST(stg.Sale_Price AS INT) AS Sale_Price,
    TRY_CAST(stg.Discount_Amount AS INT) AS Discount_Amount,

    TRY_CAST(stg.Finance_Amount AS DECIMAL(18,2)) AS Finance_Amount,

    TRY_CAST(stg.Cost_of_Repairs AS DECIMAL(18,2)) AS Cost_of_Repairs,

    TRY_CAST(stg.PC_Market_Price AS INT) AS PC_Market_Price,

    TRY_CAST(stg.Credit_Score AS INT) AS Credit_Score,

    TRY_CAST(stg.Total_Sales_per_Employee AS INT) 
        AS Total_Sales_per_Employee

FROM [pc_data_raw].[dbo].[pc_data_raw] stg


--========================================
-- CUSTOMER DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_customer] cust
ON stg.Customer_Name = cust.Customer_Name
AND stg.Customer_Surname = cust.Customer_Surname
AND stg.Customer_Contact_Number = cust.Customer_Contact_Number
AND stg.Customer_Email_Address = cust.Customer_Email_Address


--========================================
-- LOCATION DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_location] loc
ON stg.Continent = loc.Continent
AND stg.Country_or_State = loc.Country_or_State
AND stg.Province_or_City = loc.Province_or_City


--========================================
-- STORAGE DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_storage] sto
ON stg.Storage_Type = sto.Storage_Type
AND stg.RAM = sto.RAM
AND stg.Storage_Capacity = sto.Storage_Capacity


--========================================
-- PAYMENT DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_payment] pay
ON stg.Payment_Method = pay.Payment_Method


--========================================
-- SALES DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_sale] sal
ON stg.Sales_Person_Name = sal.Sales_Person_Name
AND stg.Sales_Person_Department = sal.Sales_Person_Department


--========================================
-- CHANNEL DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_channel] cha
ON stg.Channel = cha.Channel


--========================================
-- DATE DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_date] dat
ON TRY_CAST(stg.Purchase_Date AS DATE) =
   TRY_CAST(dat.Purchase_Date AS DATE)

AND ISNULL(stg.Ship_Date,'') =
    ISNULL(dat.Ship_Date,'')


--========================================
-- PC DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_pc] pc
ON stg.PC_Make = pc.PC_Make
AND stg.PC_Model = pc.PC_Model


--========================================
-- PRIORITY DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_priority] pr
ON stg.Priority = pr.Priority


--========================================
-- SHOP DIMENSION
--========================================

INNER JOIN [pc_data_raw].[dbo].[dim_shop] sho
ON stg.Shop_Name = sho.Shop_Name
AND stg.Shop_Age = sho.Shop_Age;

GO


--========================================
-- VALIDATION
--========================================

SELECT COUNT(*) AS FactRowCount
FROM [pc_data_raw].[dbo].[fact_table];


SELECT TOP 20 *
FROM [pc_data_raw].[dbo].[fact_table]
ORDER BY orderID;

--========================================
-- LOAD DATA INTO FACT TABLE
--========================================

INSERT INTO [pc_data_raw].[dbo].[fact_table]
(
    locationID,
    customerID,
    paymentID,
    saleID,
    storageID,
    priorityID,
    channelID,
    dateID,
    pcID,
    shopID,

    Cost_Price,
    Sale_Price,
    Discount_Amount,
    Finance_Amount,
    Cost_of_Repairs,
    PC_Market_Price,
    Credit_Score,
    Total_Sales_per_Employee
)

SELECT DISTINCT

    loc.locationID,
    cust.customerID,
    pay.paymentID,
    sal.saleID,
    sto.storageID,
    pr.priorityID,
    cha.channelID,
    dat.dateID,
    pc.pcID,
    sho.shopID,

    TRY_CAST(stg.Cost_Price AS INT),
    TRY_CAST(stg.Sale_Price AS INT),
    TRY_CAST(stg.Discount_Amount AS INT),

    TRY_CAST(stg.Finance_Amount AS DECIMAL(18,2)),

    TRY_CAST(stg.Cost_of_Repairs AS DECIMAL(18,2)),

    TRY_CAST(stg.PC_Market_Price AS INT),

    TRY_CAST(stg.Credit_Score AS INT),

    TRY_CAST(stg.Total_Sales_per_Employee AS INT)

FROM [pc_data_raw].[dbo].[pc_data_raw] stg


-- CUSTOMER
LEFT JOIN [pc_data_raw].[dbo].[dim_customer] cust
ON LTRIM(RTRIM(stg.Customer_Name)) =
   LTRIM(RTRIM(cust.Customer_Name))

AND LTRIM(RTRIM(stg.Customer_Surname)) =
    LTRIM(RTRIM(cust.Customer_Surname))

AND LTRIM(RTRIM(stg.Customer_Contact_Number)) =
    LTRIM(RTRIM(cust.Customer_Contact_Number))

AND LTRIM(RTRIM(stg.Customer_Email_Address)) =
    LTRIM(RTRIM(cust.Customer_Email_Address))


-- LOCATION
LEFT JOIN [pc_data_raw].[dbo].[dim_location] loc
ON LTRIM(RTRIM(stg.Continent)) =
   LTRIM(RTRIM(loc.Continent))

AND LTRIM(RTRIM(stg.Country_or_State)) =
    LTRIM(RTRIM(loc.Country_or_State))

AND LTRIM(RTRIM(stg.Province_or_City)) =
    LTRIM(RTRIM(loc.Province_or_City))


-- STORAGE
LEFT JOIN [pc_data_raw].[dbo].[dim_storage] sto
ON LTRIM(RTRIM(stg.Storage_Type)) =
   LTRIM(RTRIM(sto.Storage_Type))

AND LTRIM(RTRIM(stg.RAM)) =
    LTRIM(RTRIM(sto.RAM))

AND LTRIM(RTRIM(stg.Storage_Capacity)) =
    LTRIM(RTRIM(sto.Storage_Capacity))


-- PAYMENT
LEFT JOIN [pc_data_raw].[dbo].[dim_payment] pay
ON LTRIM(RTRIM(stg.Payment_Method)) =
   LTRIM(RTRIM(pay.Payment_Method))


-- SALES
LEFT JOIN [pc_data_raw].[dbo].[dim_sale] sal
ON LTRIM(RTRIM(stg.Sales_Person_Name)) =
   LTRIM(RTRIM(sal.Sales_Person_Name))

AND LTRIM(RTRIM(stg.Sales_Person_Department)) =
    LTRIM(RTRIM(sal.Sales_Person_Department))


-- CHANNEL
LEFT JOIN [pc_data_raw].[dbo].[dim_channel] cha
ON LTRIM(RTRIM(stg.Channel)) =
   LTRIM(RTRIM(cha.Channel))


-- DATE
LEFT JOIN [pc_data_raw].[dbo].[dim_date] dat
ON TRY_CAST(stg.Purchase_Date AS DATE) =
   TRY_CAST(dat.Purchase_Date AS DATE)

AND ISNULL(LTRIM(RTRIM(stg.Ship_Date)), '') =
    ISNULL(LTRIM(RTRIM(dat.Ship_Date)), '')


-- PC
LEFT JOIN [pc_data_raw].[dbo].[dim_pc] pc
ON LTRIM(RTRIM(stg.PC_Make)) =
   LTRIM(RTRIM(pc.PC_Make))

AND LTRIM(RTRIM(stg.PC_Model)) =
    LTRIM(RTRIM(pc.PC_Model))


-- PRIORITY
LEFT JOIN [pc_data_raw].[dbo].[dim_priority] pr
ON LTRIM(RTRIM(stg.Priority)) =
   LTRIM(RTRIM(pr.Priority))


-- SHOP
LEFT JOIN [pc_data_raw].[dbo].[dim_shop] sho
ON LTRIM(RTRIM(stg.Shop_Name)) =
   LTRIM(RTRIM(sho.Shop_Name))

AND TRY_CAST(stg.Shop_Age AS INT) =
    TRY_CAST(sho.Shop_Age AS INT);

GO