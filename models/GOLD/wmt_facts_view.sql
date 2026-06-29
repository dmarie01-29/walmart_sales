{{ config(
    materialized='view',
    alias='wmt_fact_view',
    schema='GOLD'
) }}

with fact_view as(
    select
        store_id
        , dept_id        
        , store_size 
        , date_id 
        , store_date
        , isholiday
        , weekly_sales
        , fuel_price
        , temperature
        , unemployment
        , cpi
        , markdown1
        , markdown2
        , markdown3
        , markdown4
        , markdown5        
        , version_startdate
    from {{ ref('transform_wmt_fact_table') }} 

    where current_date() between version_startdate and version_enddate
)

select * from fact_view