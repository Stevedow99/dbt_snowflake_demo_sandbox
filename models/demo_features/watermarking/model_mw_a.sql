{{
    config(
        materialized='table'
    )
}}

SELECT
  ID,
  STATUS,
  CREATED_TIMESTAMP,
  MODIFIED_TIMESTAMP
FROM {{ source('sample_data', 'example_orders_table') }}
WHERE MODIFIED_TIMESTAMP > {{get_high_watermark('model_mw_c', 'MODIFIED_TIMESTAMP')}}