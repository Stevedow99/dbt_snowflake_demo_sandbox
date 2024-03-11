
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
        array_size(failed_validations) as number_of_failed_validations,
        array_contains('number_of_student_above_1000'::variant, failed_validations) as number_of_students_validation_failed,
        array_contains('data_entry_confidence_greater_than_fifty_percent'::variant, failed_validations) as number_of_students_validation_failed,
        array_contains('school_achievement_rating_above_above_two'::variant, failed_validations) as number_of_students_validationschool_achievement_rating_validation_failed_failed
    from base_model_with_assertions
)


select
*
from output_table