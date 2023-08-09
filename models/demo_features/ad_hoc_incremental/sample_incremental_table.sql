{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        on_schema_change='append_new_columns'
    )
}}


select 
*,
1 as my_new_column
from {{ source('sample_data', 'example_orders_table_two') }}

{% if is_incremental() %}

  where MODIFIED_TIMESTAMP > (select max(MODIFIED_TIMESTAMP) from {{ this }})

{% endif %}