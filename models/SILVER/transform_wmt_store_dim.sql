{{ config(
    materialized='table',
    alias='wmt_store_dim',
    schema='SILVER'
) }}
with store_dim as (
    select
        d.store as store_id
        , d.dept as dept_id
        , s.type as store_type
        , s.size as store_size
        , d.insert_dts as insert_date
        , d.update_dts as update_date
    from {{ ref('load_department_table') }} as d

    join {{ ref('load_stores_table')}} as s
    on d.store = s.store

)

select  
    store_id
    , dept_id
    , store_type
    , store_size
    , insert_date
    , update_date
from store_dim
