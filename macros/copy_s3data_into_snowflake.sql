-- {% macro macros_copy_csv(table_nm) %}

-- delete from {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }};

-- COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }} 
-- (
--     STORE, DEPT, STORE_DATE, WEEKLY_SALES, IS_HOLIDAY, 
--     SOURCE_FILE_NAME, SOURCE_FILE_ROW_NUMBER, INSERT_DTS, UPDATE_DTS
-- )
-- FROM (
--     SELECT 
--         $1, $2, $3, $4, $5, 
--         metadata$filename, 
--         metadata$file_row_number, 
--         CURRENT_TIMESTAMP(), 
--         CURRENT_TIMESTAMP()
--     FROM @{{ var('stage_name') }}
-- )
-- FILE_FORMAT = {{var ('file_format') }}
-- PATTERN = '.*{{ table_nm | lower }}.*\\.csv' 
-- PURGE={{ var('purge_status') }}
-- FORCE = TRUE
-- ;

-- {% endmacro %}

{% macro macros_copy_csv(table_nm) %} 

DELETE FROM {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }}; 

COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }} 
FROM @{{ var('stage_name') }}

INCLUDE_METADATA = (
  INSERT_DTS = METADATA$START_SCAN_TIME,
  UPDATE_DTS = METADATA$START_SCAN_TIME,
  SOURCE_FILE_NAME = METADATA$FILENAME,
  SOURCE_FILE_ROW_NUMBER = METADATA$FILE_ROW_NUMBER
)

FILES = ('{{ table_nm | lower }}.csv') 
FILE_FORMAT = {{ var('file_format') }}
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE 
PURGE = {{ var('purge_status') }} 
FORCE = TRUE; 

{% endmacro %}


