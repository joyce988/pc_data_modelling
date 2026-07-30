CREATE PROCEDURE [dbo].[sp_create_dim_date]

AS
BEGIN
drop table dim_date
create table dim_date

([dateID] INT IDENTITY(1,1) PRIMARY KEY,
[Purchase_Date] [datetime2](7) NOT NULL,
	[Ship_Date] [nvarchar](50) NOT NULL,
  [Load_date] DATETIME DEFAULT GETDATE()    )

INSERT INTO [pc_data_raw].[dbo].[dim_date](
	Purchase_Date,
	Ship_Date )
SELECT DISTINCT Purchase_Date,
	Ship_Date 
	
  FROM [pc_data_raw].[dbo].[pc_data_raw]

   SELECT*
  FROM [pc_data_raw].[dbo].[dim_date]

 END;
GO
