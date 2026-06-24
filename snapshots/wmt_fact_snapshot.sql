{% snapshot wmt_fact_snapshot %}
{{
    config(
      target_database='WMT_DB',
      target_schema='BRONZE',
      unique_key= "STORE || '-' || DATE",
      strategy='check',
      check_cols=['TEMPERATURE', 'FUEL_PRICE', 'MARKDOWN1', 'MARKDOWN2', 'MARKDOWN3', 'MARKDOWN4','MARKDOWN5', 'CPI', 'UNEMPLOYMENT', 'ISHOLIDAY'],
    )
}}
select * from {{ source('transform', 'FACT') }}
{% endsnapshot %}