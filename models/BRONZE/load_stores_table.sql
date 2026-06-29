{{ config(
    materialized='table',
    transient=true,
    pre_hook=macros_copy_csv('STORES')
) }}

WITH raw_stores AS(
SELECT
    store
    ,type
    ,size
    ,insert_dts 
    ,update_dts 
    ,source_file_name 
    ,source_file_row_number 
FROM {{source('wmt_raw_landing','STORES')}}
)

SELECT *
FROM raw_stores


