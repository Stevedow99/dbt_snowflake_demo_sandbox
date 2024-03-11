
{{
    config(
        materialized='ephemeral'
    )
}}

select

*

from {{ source('school_data', 'school_districts') }}
where 
    dbt_ready = true
    and file_processed = false
    and file_name = {{ var('school_file_name') }}