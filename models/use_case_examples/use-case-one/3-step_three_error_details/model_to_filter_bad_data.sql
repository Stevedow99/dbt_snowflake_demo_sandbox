{{
    config(
        materialized='incremental_custom',
        incremental_strategy='merge',
        on_schema_change='append_new_columns',
        unique_key='record_id'
    )
}}

with base as (
select * 
from {{ ref('staging_model_base') }}

-- filtering for rows that failed validation
WHERE {{ dbt_assertions.assertions_filter(reverse=True) }} )


select 
*
from base


{% if is_incremental_custom_check() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}
