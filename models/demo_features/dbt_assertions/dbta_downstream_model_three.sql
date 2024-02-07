{{
    config(
        materialized='table'
    )
}}


Select
    *
from {{ ref('dbta_downstream_model_one') }}
WHERE {{ dbt_assertions.assertions_filter() }}
