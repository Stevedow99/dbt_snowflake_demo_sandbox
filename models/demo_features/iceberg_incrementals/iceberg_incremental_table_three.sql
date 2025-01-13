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


select 
    id,
    status,
    CAST(CREATED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS CREATED_TIMESTAMP,
    CAST(MODIFIED_TIMESTAMP AS TIMESTAMP_LTZ(6)) AS MODIFIED_TIMESTAMP
from {{ source('sample_data', 'example_orders_table_two') }}


{% if is_incremental() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}