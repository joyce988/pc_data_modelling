

CREATE PROCEDURE [dbo].[sp_create_dim_location]

AS
BEGIN
drop table dim_location
 create table dim_location
 ( [locationID] INT IDENTITY(1,1) PRIMARY KEY,
  [continent][nvarchar](50) NOT NULL,
  [country_or_state][nvarchar](50) NOT NULL,
  [province_or_city] [nvarchar](100) NOT NULL)

  --INSERTING INFORMATION INTO DIM_LOCATION TABLE.

  INSERT INTO [pc_data_raw].[dbo].[dim_location](continent,country_or_state,province_or_city)
  SELECT DISTINCT continent,country_or_state,province_or_city
   FROM [pc_data_raw].[dbo].[pc_data_raw]

  select *
  from [pc_data_raw].[dbo].[pc_data_raw]

 END;
GO
