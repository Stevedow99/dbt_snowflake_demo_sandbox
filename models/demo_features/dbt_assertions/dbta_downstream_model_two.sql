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
),

mfa_assertions_applied as 
(
    Select
    *,
    {{ dbt_assertions.assertions() | indent(4) }}
from mfa
)

Select
    *
from mfa_assertions_applied
WHERE {{ dbt_assertions.assertions_filter() }}
