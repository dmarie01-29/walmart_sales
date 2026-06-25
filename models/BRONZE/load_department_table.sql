{{ config(
    materialized='table',
    transient=true,
    pre_hook=macros_copy_csv('DEPARTMENT')
) }}

with raw_dept as (
    select 
        store 
        ,dept 
        ,date 
        ,weekly_sales 
        ,isholiday 
        ,insert_dts 
        ,update_dts 
        ,source_file_name 
        ,source_file_row_number 
    from {{ source('wmt_raw_landing', 'DEPARTMENT') }}
)

select * from raw_dept
