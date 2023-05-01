{% set snowflake_query_tag_input =  invocation_id ~ " | " ~ this.name ~ " | " ~ this %}


{{ config(
    materialized='incremental',
    incremental_strategy='append',
    query_tag = snowflake_query_tag_input
) }}

SELECT
  ID,
  STATUS,
  CREATED_TIMESTAMP,
  MODIFIED_TIMESTAMP
FROM {{ source('sample_data', 'example_orders_table') }}