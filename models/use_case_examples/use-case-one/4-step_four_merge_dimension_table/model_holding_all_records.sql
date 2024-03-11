{{
    config(
        materialized='incremental_custom',
        incremental_strategy='merge',
        on_schema_change='append_new_columns',
        unique_key='record_id',
        post_hook= "UPDATE {{ source('school_data', 'school_districts')}} SET FILE_PROCESSED = TRUE WHERE FILE_NAME = '{{var('school_file_name')}}' "
    )
}}


select * 
from {{ ref('staging_model_base') }}