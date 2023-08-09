{{
    config(
        materialized='incremental_custom',
        incremental_strategy='merge',
        on_schema_change='sync_all_columns',
        delete_target_not_in_source=True,
        unique_key='id'
    )
}}


select * exclude status
from {{ source('sample_data', 'example_orders_table_two') }}