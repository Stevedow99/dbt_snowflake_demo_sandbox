{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        on_schema_change='append_new_columns',
        unique_key='id',
        table_format="iceberg",
        external_volume="sd_iceberg_external_volume"
    )
}}


select * 
from {{ source('sample_data', 'example_orders_table_two') }}


{% if is_incremental_custom_check() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}