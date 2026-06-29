{{ config(
    materialized='table',
    transient=true,
    pre_hook=macros_copy_csv('FACT')
) }}

with raw_facts as(
select
    store
    ,date
    ,temperature
    ,fuel_price
    ,markdown1
    ,markdown2
    ,markdown3
    ,markdown4
    ,markdown5
    ,cpi
    ,unemployment
    ,isholiday
    ,insert_dts 
    ,update_dts 
    ,source_file_name 
    ,source_file_row_number 
from {{source('wmt_raw_landing','FACT')}}
)

select *
from raw_facts