{% set query_tag_text = model_name ~ " | " ~ model.path  ~ " | " ~ invocation_id %}

{{
    config(
        materialized='table',
        query_tag = query_tag_text
    )
}}

SELECT
  ID,
  STATUS,
  CREATED_TIMESTAMP,
  MODIFIED_TIMESTAMP
FROM {{ source('sample_data', 'example_orders_table') }}
WHERE MODIFIED_TIMESTAMP > {{get_high_watermark('model_mw_b', 'MODIFIED_TIMESTAMP')}}