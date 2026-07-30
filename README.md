# PC Data Modelling

## Project Overview

This repository contains a SQL-based data engineering project for building a PC sales data warehouse model. It includes scripts for:

- creating local SQL Server databases
- loading raw sales data into a staging table
- generating dimension tables from raw attributes
- constructing a fact table with foreign key references
- checking and cleaning duplicate records
- packaging table creation logic into stored procedures

## Databases

The project is designed around two databases:

- `pc_data_raw` – raw/staging database where the source table and most dimension/fact tables are created
- `pc_data_dwh` – intended data warehouse database created by the project, though most object scripts currently target `pc_data_raw`

## Key Files

### Root-level files

- `creating database.sql` – creates the `pc_data_raw` and `pc_data_dwh` databases
- `dbo_pc_data_raw.sql` – contains raw SELECTs and the early dimension/fact table construction logic from the raw source table
- `checking_duplicates.sql` – validates and removes duplicate rows in dimension tables and checks fact-to-dimension joins
- `1772542271737_pc_data (2).csv` – raw input data file for the project
- `data_analysis.py` – Python data analysis script that reads the dataset, creates summary statistics, and writes graphs/diagrams to `analysis_output/`

### Dimension and fact table scripts

Stored in `dim tables and fact table/`:

- `creating dim_customer_table.sql`
- `creating dim_table_location.sql`
- `dim_channel.sql`
- `dim_date.sql`
- `dim_payment_table.sql`
- `dim_pc.sql`
- `dim_priority.sql`
- `dim_sale_table.sql`
- `dim_shop.sql`
- `creating dim-storage_table.sql`
- `fact_table.sql`

These scripts create each dimension table and assemble the `fact_table` by joining raw data with dimension rows.

### Stored procedures

Stored in `stored_procedures/`:

- `customer_stored_procedures.sql`
- `dim_channel_stored procedures.sql`
- `dim_date_stored procedures.sql`
- `dim_prioritiy_stored procedures.sql`
- `location_stored_procedures.sql`
- `payment_stored_procedures.sql`
- `pc_stored_procedures.sql`
- `shop_stored procedures_dim.sql`
- `storage_stored_procedures.sql`

Each procedure encapsulates create-and-load logic for a single dimension table.

## Data Model

The model is a star schema with the following core tables:

### Dimension tables

- `dim_customer`
- `dim_location`
- `dim_payment`
- `dim_sale`
- `dim_storage`
- `dim_date`
- `dim_channel`
- `dim_priority`
- `dim_pc`
- `dim_shop`

### Fact table

- `fact_table`

The fact table contains foreign keys to the dimension tables plus measures such as:

- `Cost_Price`
- `Sale_Price`
- `Discount_Amount`
- `Finance_Amount`
- `Cost_of_Repairs`
- `PC_Market_Price`
- `Credit_Score`
- `Total_Sales_per_Employee`

## Recommended Workflow

1. Create the databases using `creating database.sql`.
2. Load raw data into the source table in `pc_data_raw.dbo`.
3. Run each dimension table script in `dim tables and fact table/` or execute the stored procedures in `stored_procedures/`.
4. Build the `fact_table` by running `fact_table.sql`.
5. Use `checking_duplicates.sql` to validate and clean duplicate dimension records and verify referential data quality.

## Notes

- Some scripts currently operate directly against `pc_data_raw`, so confirm the intended target database before executing in production.
- The raw staging table is expected to contain all source columns such as customer, location, payment, sales, PC, storage, channel, priority, date, and shop data.
- Duplicate cleanup is included for dimension tables and diagnostic joins are provided to identify missing matches.

## Contact

For walkthroughs or further enhancements, review the SQL scripts in the root and subfolders to understand how each dimension and fact table is constructed.
