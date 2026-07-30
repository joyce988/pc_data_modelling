drop table dim_pc
create table dim_pc

([pcID] INT IDENTITY(1,1) PRIMARY KEY,
[PC_Make] [nvarchar](50) NOT NULL,
	[PC_Model] [nvarchar](50) NOT NULL,
  [Load_date] DATETIME DEFAULT GETDATE()    )

INSERT INTO [pc_data_raw].[dbo].[dim_pc](PC_Make, 
	PC_Model)
SELECT DISTINCT PC_Make,
	PC_Model
  FROM [pc_data_raw].[dbo].[pc_data_raw]

   SELECT*
  FROM [pc_data_raw].[dbo].[dim_pc]
