{{
    config(
        materialized='ephemeral'
    )
}}


Select
    *
from {{ ref('base_model_w_assertions') }}
WHERE {{ dbt_assertions.assertions_filter() }}