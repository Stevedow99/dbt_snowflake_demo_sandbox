{{
    config(
        materialized='table'
    )
}}

with mfa as (
    Select
        my_frist_column,
        a_simple_calculation,
        current_time
    from {{ ref('dbta_upstream_model_one') }}
)

Select
    *,
    {{ dbt_assertions.assertions() | indent(4) }}
from mfa