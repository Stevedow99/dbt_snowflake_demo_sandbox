{{
  config(
    materialized = "insert_by_period",
    period = "day",
    timestamp_field = "modified_timestamp",
    start_date = var('ibp_start_date'),
    stop_date = var('ibp_end_date'))
}}

select
  id,
  status,
  created_timestamp,
  modified_timestamp
  
from {{ source('sample_data', 'example_orders_table') }}
WHERE __PERIOD_FILTER__ 