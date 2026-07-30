drop table dim_shop
create table dim_shop

([shopID] INT IDENTITY(1,1) PRIMARY KEY,
[Shop_Name] nvarchar (50) NOT NULL,
[Shop_Age] nvarchar(50) not null, 
  [Load_date] DATETIME DEFAULT GETDATE()    )

INSERT INTO [pc_data_raw].[dbo].[dim_shop](shop_name, shop_Age)
SELECT DISTINCT shop_name, shop_Age 
  FROM [pc_data_raw].[dbo].[pc_data_raw]

   SELECT*
  FROM [pc_data_raw].[dbo].[dim_shop]

    