drop table dim_priority
create table dim_priority

([priorityID] INT IDENTITY(1,1) PRIMARY KEY,
[Priority] [nvarchar](50) NOT NULL,
  [Load_date] DATETIME DEFAULT GETDATE()    )

INSERT INTO [pc_data_raw].[dbo].[dim_priority](
	priority)
SELECT DISTINCT priority
  FROM [pc_data_raw].[dbo].[pc_data_raw]

   SELECT*
  FROM [pc_data_raw].[dbo].[dim_priority]
