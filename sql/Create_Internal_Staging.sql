--- Create Internal Stage

--- Create a CSV File format
CREATE OR REPLACE FILE FORMAT csv_std
  TYPE = CSV
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  TRIM_SPACE = TRUE
  NULL_IF = ('', 'NULL', 'null');

CREATE OR REPLACE STAGE cloud_stage
  FILE_FORMAT = csv_std
  COMMENT = 'Internal stage for CloudLoad';
