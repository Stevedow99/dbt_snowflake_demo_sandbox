{{
    config(
        materialized='incremental_custom',
        incremental_strategy='merge',
        on_schema_change='append_new_columns',
        unique_key='id'
    )
}}


select * 
from {{ source('sample_data', 'example_orders_table_two') }}


{% if is_incremental() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}