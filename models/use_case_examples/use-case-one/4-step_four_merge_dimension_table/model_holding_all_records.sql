{{
    config(
        materialized='incremental_custom',
        incremental_strategy='merge',
        on_schema_change='append_new_columns',
        unique_key='record_id',
        post_hook= "UPDATE {{ source('school_data', 'school_districts')}} SET WHERE FILE_NAME = '{{var('school_file_name')}}' "
    )
}}


select * 
from {{ ref('staging_model_base') }}


{% if is_incremental_custom_check() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}
