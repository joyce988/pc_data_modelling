
CREATE PROCEDURE [dbo].[sp_create_dim_payment]

AS
BEGIN

drop table dim_payment
CREATE TABLE dim_payment
([paymentID] INT IDENTITY(1,1) PRIMARY KEY,
[Payment_Method][nvarchar](50) NOT NULL)

INSERT INTO [pc_data_raw].[dbo].[dim_payment](payment_method)
SELECT DISTINCT payment_method
  FROM [pc_data_raw].[dbo].[pc_data_raw]

   SELECT*
  FROM [pc_data_raw].[dbo].[dim_payment]



 END;
GO
