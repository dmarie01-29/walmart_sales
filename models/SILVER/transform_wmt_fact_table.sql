{{ config(
    materialized='table',
    alias='wmt_fact_table',
    schema='SILVER'
) }}
with fact_table as (
    select
        d.store as store_id
        , d.dept as dept_id
        , s.size as store_size
        , d.date as store_date
        , d.isholiday as isholiday
        , d.weekly_sales as weekly_sales
        , f.fuel_price as fuel_price
        , f.temperature as temperature
        , f.unemployment as unemployment
        , f.cpi as cpi
        , f.markdown1 as markdown1
        , f.markdown2 as markdown2
        , f.markdown3 as markdown3
        , f.markdown4 as markdown4
        , f.markdown5 as markdown5
        , f.insert_dts as insert_date
        , f.update_dts as update_date
        , f.dbt_valid_from as version_startdate
        , coalesce(f.dbt_valid_to, '9999-12-31 00:00:00.000') as version_enddate
        , to_number(to_varchar(d.date, 'YYYYMMDD')) as date_id
    from {{ ref('load_department_table') }} as d

    join {{ ref('wmt_fact_snapshot')}} as f
    on f.store = d.store
    and f.date = d.date

    join {{ ref('load_stores_table')}} as s
    on s.store = d.store

)

select  *  from fact_table