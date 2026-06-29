{{ config(
    materialized='table',
    alias='wmt_date_dim',
    schema='SILVER'
) }}

with ranked_dates as (
    select
        -- Create an integer date ID (e.g., 2026-06-25 becomes 20260625)
        to_number(to_varchar(date, 'YYYYMMDD')) as date_id,
        date,
        isholiday,
        insert_dts as insert_date,
        update_dts as update_date
    from {{ ref('load_department_table') }}
    -- Filter out any duplicate rows per date, keeping the most recently updated one
    qualify row_number() over (
        partition by date 
        order by update_date desc, insert_date desc
    ) = 1
)

select 
    date_id,
    date,
    isholiday,
    insert_date,
    update_date
from ranked_dates
