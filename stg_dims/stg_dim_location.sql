-- Create stg_dim_location table only if it does not exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.tables 
    WHERE name = 'stg_dim_location'
)
BEGIN

    CREATE TABLE [pc_data_staging].[dbo].[stg_dim_location]
    (
        [locationID] INT IDENTITY(1,1) PRIMARY KEY,
        [continent] NVARCHAR(50) NOT NULL,
        [country_or_state] NVARCHAR(50) NOT NULL,
        [province_or_city] NVARCHAR(100) NOT NULL
    );

END;
GO

-- Insert data only if it does not already exist
INSERT INTO [pc_data_staging].[dbo].[stg_dim_location]
(
    continent,
    country_or_state,
    province_or_city
)
SELECT DISTINCT
    continent,
    country_or_state,
    province_or_city
FROM [pc_data_staging].[dbo].[pc_data_raw] stg

WHERE NOT EXISTS
(
    SELECT 1
    FROM [pc_data_staging].[dbo].[stg_dim_location] l
    WHERE l.continent = stg.continent
      AND l.country_or_state = stg.country_or_state
      AND l.province_or_city = stg.province_or_city
);

-- View inserted data
SELECT *
FROM [pc_data_staging].[dbo].[stg_dim_location];
GO