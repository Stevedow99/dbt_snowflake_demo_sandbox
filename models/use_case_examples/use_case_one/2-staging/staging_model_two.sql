
{{
    config(
        materialized='ephemeral'
    )
}}

select
    record_id,
    district_id,
    district_name,
    school_name,
    number_of_students,
    data_entry_confidence,
    school_achievement_rating,
    file_name,
    dbt_ready,
    file_processed,
    created_timestamp,
    modifed_timestamp

from {{ source('school_data', 'school_districts') }}
where 
    dbt_ready = true
    and file_processed = false
    and file_name = {{ var('school_file_name') }}