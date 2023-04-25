{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}


select
  ID,
  STATUS,
  CREATED_TIMESTAMP,
  MODIFIED_TIMESTAMP
from {{ ref('model_mw_a') }}