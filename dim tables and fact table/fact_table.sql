  drop table [pc_data_raw].[dbo].[fact_table]

CREATE TABLE [pc_data_raw].[dbo].[fact_table]

([orderID] INT IDENTITY(1,1) PRIMARY KEY,
[locationID] INT ,
[customerID] INT ,
[paymentID] INT ,
[saleID] INT ,
[storageID] INT ,
[priorityID] INT,
[channelID] INT,
[dateID] INT,
[pcID] INT,
[shopID] int,
[Cost_Price] INT NOT NULL,
[Sale_Price] INT NOT NULL,
[Discount_Amount] INT NOT NULL,
[Finance_Amount] [nvarchar](50) NOT NULL,
[Cost_of_Repairs] [nvarchar](50) NOT NULL,
[PC_Market_Price] INT NOT NULL,
[Credit_Score] INT NOT NULL,
[Total_Sales_per_Employee] INT NOT NULL,
[Load_date] DATETIME DEFAULT GETDATE(),

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
references [pc_data_raw].[dbo].[dim_storage](storageID),



CONSTRAINT fk_channelID
foreign key(channelID)
references [pc_data_raw].[dbo].[dim_channel](channelID),


CONSTRAINT fk_priorityID
foreign key(priorityID)
references [pc_data_raw].[dbo].[dim_priority](priorityID),


CONSTRAINT fk_dateID
foreign key(dateID)
references [pc_data_raw].[dbo].[dim_date](dateID),

CONSTRAINT fk_pcID
foreign key(pcID)
references [pc_data_raw].[dbo].[dim_pc](pcID),

CONSTRAINT fk_shopID
foreign key(shopID)
references [pc_data_raw].[dbo].[dim_shop](shopID)

  );
  
  
  go

  --insert data into table
  insert into [pc_data_raw].[dbo].[fact_table] ( locationID, customerID , paymentID, saleID, storageID,priorityID,channelID,dateID,pcID, shopID,
                          Cost_Price, Sale_Price, Discount_Amount, Finance_Amount, 
                                                  Cost_of_Repairs,  PC_Market_Price, Credit_Score ,Total_Sales_per_Employee)
  select distinct loc.locationID, cust.customerID , pay.paymentID, sal.saleID, sto.storageID,pr.priorityID,cha.channelID,dat.dateID,pc.pcID, sho.shopID,
                          stg.Cost_Price, stg.Sale_Price, stg.Discount_Amount, stg.Finance_Amount, 
                                                  stg.Cost_of_Repairs,  stg.PC_Market_Price,stg.Credit_Score ,stg.Total_Sales_per_Employee

  from [pc_data_raw].[dbo].[pc_data_raw] stg
 

 inner join [pc_data_raw].[dbo].[dim_customer] cust
   on stg.Customer_Name =cust.Customer_Name
    and stg.Customer_Surname =cust.Customer_Surname
    and stg.Customer_Contact_Number=cust.Customer_Contact_Number
    and stg.Customer_Email_Address =cust.Customer_Email_Address

   inner join [pc_data_raw].[dbo].[dim_location] loc
    on stg.Continent=loc.Continent
    and stg.Country_or_State=loc.Country_or_State
    and stg.Province_or_City= loc.Province_or_City

  
   
   inner join [pc_data_raw].[dbo].[dim_storage] sto 
   on stg.Storage_Type= sto.Storage_Type
   and stg.RAM= sto.RAM
   and stg.Storage_Capacity=sto.Storage_Capacity
     
      
    inner join [pc_data_raw].[dbo].[dim_payment] pay
    on stg.Payment_Method=pay.Payment_Method
      

   inner join [pc_data_raw].[dbo].[dim_sale] sal
   on stg.Sales_Person_Name= sal.Sales_Person_Name
   and stg.Sales_Person_Department= sal.Sales_Person_Department

   inner join  [pc_data_raw].[dbo].[dim_channel] cha
   on stg.Channel = cha.Channel


inner join  [pc_data_raw].[dbo].[dim_date] dat
ON stg.Purchase_Date  = dat.Purchase_Date
AND stg.Ship_Date  = dat.Ship_Date 

inner join [pc_data_raw].[dbo].[dim_pc] pc
on stg.PC_Make = pc.PC_Make
and stg.PC_Model = pc.PC_Model

inner join [pc_data_raw].[dbo].[dim_priority] pr
on stg.Priority = pr.Priority

inner join [pc_data_raw].[dbo].[dim_shop] sho
on stg.Shop_Name = sho.Shop_Name
and stg.Shop_Age=sho.Shop_Age;
   
   go
  
     
  --select all data from orders_fact

  select* from [pc_data_raw].[dbo].[fact_table];


 --Validation output
SELECT COUNT(*) AS FactRowCount FROM dbo.fact_table;
SELECT TOP (20) * FROM dbo.fact_table ORDER BY orderID;