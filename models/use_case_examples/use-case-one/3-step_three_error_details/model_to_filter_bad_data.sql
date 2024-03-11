{{
    config(
        materialized='incremental_custom',
        incremental_strategy='merge',
        on_schema_change='append_new_columns',
        unique_key='record_id'
    )
}}


select * 
from {{ ref('staging_model_base') }}

-- filtering for rows that failed validation
WHERE {{ dbt_assertions.assertions_filter(reverse=True) }}