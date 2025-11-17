CREATE OR REPLACE WAREHOUSE WH_CLOUDLOAD
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Warehouse for CloudLoad Data Warehouse Integration project';

-- STEP 2: Create a database

CREATE OR REPLACE DATABASE CLOUDLOAD_DB
  COMMENT = 'Database for CloudLoad Data Warehouse Integration project';
  
