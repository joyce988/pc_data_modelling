CREATE PROCEDURE [dbo].[sp_create_dim_channel]

AS
BEGIN
drop table dim_channel
create table dim_channel

([channelID] INT IDENTITY(1,1) PRIMARY KEY,
[Channel] [nvarchar](50) NOT NULL,
  [Load_date] DATETIME DEFAULT GETDATE()    )

INSERT INTO [pc_data_raw].[dbo].[dim_channel](
	channel)
SELECT DISTINCT channel
  FROM [pc_data_raw].[dbo].[pc_data_raw]

   SELECT*
  FROM [pc_data_raw].[dbo].[dim_channel]

 END;
GO
