{{
    config(
        materialized='incremental'
    )
}}

select
  id,
  status,
  created_timestamp,
  modified_timestamp
  
from {{ source('sample_data', 'example_orders_table_two') }}

{% if is_incremental() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}