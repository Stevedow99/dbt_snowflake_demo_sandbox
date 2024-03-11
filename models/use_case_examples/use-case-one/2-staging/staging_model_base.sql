
{{
    config(
        materialized='ephemeral'
    )
}}

with base_model as (
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
    and file_name = '{{ var('school_file_name') }}'),

base_model_with_assertions as (
     Select
        *,
        {{ dbt_assertions.assertions() | indent(4) }}
    from base_model
),

output_table as (
    select
        *,
        array_size(failed_validations) as number_of_failed_validations
    from base_model_with_assertions
)


select
*
from output_table