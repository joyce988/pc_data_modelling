--checking duplicates and fix them from all dim tables
--dim_customer
select Customer_Name,
      Customer_Surname,
      Customer_Contact_Number,
      Customer_Email_Address, count(*)
  FROM [pc_data_raw].[dbo].[dim_customer]
  group by Customer_Name,
      Customer_Surname,
      Customer_Contact_Number,
      Customer_Email_Address
having count(*)>1;


WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                Customer_Name,
                Customer_Surname,
                Customer_Contact_Number,
                Customer_Email_Address
            ORDER BY Customer_Name
        ) AS RowNumber
    FROM [pc_data_raw].[dbo].[dim_customer]
)

DELETE FROM CTE
WHERE RowNumber > 1;

--dim_location
select continent,
      country_or_state,
      province_or_city, count(*)
      FROM [pc_data_raw].[dbo].[dim_location]
  
  group by continent,
      country_or_state,
      province_or_city
      having count(*)>1
--dim_payment
    select Payment_Method, count(*)
  FROM [pc_data_raw].[dbo].[dim_payment]
 
    group by Payment_Method
    having count(*)>1

    --dim_sale
    select [Sales_Person_Name]
      ,[Sales_Person_Department],count(*)
  FROM [pc_data_raw].[dbo].[dim_sale]
 
    group by [Sales_Person_Name]
      ,[Sales_Person_Department]
    having count(*)>1
    --dim_storage
    select [Storage_Type]
      ,[RAM]
      ,[Storage_Capacity],count(*)
  FROM [pc_data_raw].[dbo].[dim_storage]
 
    group by [Storage_Type]
      ,[RAM]
      ,[Storage_Capacity]
    having count(*)>1


    --fact_table
    select [locationID]
      ,[customerID]
      ,[paymentID]
      ,[saleID]
      ,[storageID]
      ,[Cost_Price]
      ,[Sale_Price]
      ,[Discount_Amount]
      ,[Finance_Amount]
      ,[Cost_of_Repairs]
      ,[PC_Market_Price],count(*)
  FROM [pc_data_raw].[dbo].[fact_table]
        
    group by [locationID]
      ,[customerID]
      ,[paymentID]
      ,[saleID]
      ,[storageID]
      ,[Cost_Price]
      ,[Sale_Price]
      ,[Discount_Amount]
      ,[Finance_Amount]
      ,[Cost_of_Repairs]
      ,[PC_Market_Price]
    having count(*)>1

    -- 4. Diagnostics for missing dimension matches
SELECT stg.*
FROM dbo.pc_data_raw AS stg
LEFT JOIN dbo.dim_customer cust
    ON stg.Customer_Name = cust.Customer_Name
    AND stg.Customer_Surname = cust.Customer_Surname
    AND stg.Customer_Contact_Number = cust.Customer_Contact_Number
    AND stg.Customer_Email_Address = cust.Customer_Email_Address
LEFT JOIN dbo.dim_location loc
    ON stg.Continent = loc.continent
    AND stg.Country_or_State = loc.country_or_state
    AND stg.Province_or_City = loc.province_or_city
LEFT JOIN dbo.dim_storage sto
    ON stg.Storage_Type = sto.Storage_Type
    AND stg.RAM = sto.RAM
    AND stg.Storage_Capacity = sto.Storage_Capacity
LEFT JOIN dbo.dim_payment pay
    ON stg.Payment_Method = pay.Payment_Method
LEFT JOIN dbo.dim_sale sal
    ON stg.Sales_Person_Name = sal.Sales_Person_Name
    AND stg.Sales_Person_Department = sal.Sales_Person_Department
LEFT JOIN dbo.dim_channel cha
    ON stg.Channel = cha.Channel
LEFT JOIN dbo.dim_priority pr
    ON stg.Priority = pr.Priority
LEFT JOIN dbo.dim_pc pc
    ON stg.PC_Make = pc.PC_Make
    AND stg.PC_Model = pc.PC_Model
LEFT JOIN dbo.dim_shop shop
    ON stg.Shop_Name = shop.Shop_Name
    AND stg.Shop_Age = shop.Shop_Age
LEFT JOIN dbo.dim_date dat
on stg.Purchase_date= dat.purchase_date
and stg.ship_date=dat.ship_date
  
WHERE cust.customerID IS NULL
   OR loc.locationID IS NULL
   OR sto.storageID IS NULL
   OR pay.paymentID IS NULL
   OR sal.saleID IS NULL
   OR cha.channelID IS NULL
   OR pr.priorityID IS NULL
   OR pc.pcID IS NULL
   OR shop.shopID IS NULL
   OR dat.dateID IS NULL;
