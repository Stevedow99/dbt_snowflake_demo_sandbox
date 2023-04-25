{% set query_tag_text = model_name ~ " | " ~ model.path  ~ " | " ~ invocation_id %}

{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        query_tag = query_tag_text
    )
}}


select
  ID,
  STATUS,
  CREATED_TIMESTAMP,
  MODIFIED_TIMESTAMP
from {{ ref('model_mw_a') }}