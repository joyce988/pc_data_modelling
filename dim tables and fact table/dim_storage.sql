drop table dim_storage

CREATE TABLE dim_storage
([storageID] INT IDENTITY(1,1) PRIMARY KEY,
 [Storage_Type][nvarchar](50) NOT NULL,
      [RAM][nvarchar](50) NOT NULL,
      [Storage_Capacity][nvarchar](50))

 
INSERT INTO [pc_data_raw].[dbo].[dim_storage](
	storage_type,RAM,storage_capacity)
SELECT DISTINCT storage_type,RAM,storage_capacity
  FROM [pc_data_raw].[dbo].[pc_data_raw]
