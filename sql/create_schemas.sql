-- STEP 3: Create two schemas - RAW and ANALYTICS

CREATE OR REPLACE SCHEMA CLOUDLOAD_DB.RAW
  COMMENT = 'Schema to store raw ingested data';

CREATE OR REPLACE SCHEMA CLOUDLOAD_DB.ANALYTICS
  COMMENT = 'Schema for transformed and aggregated data';
