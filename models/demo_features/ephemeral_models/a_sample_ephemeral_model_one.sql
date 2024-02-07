{{
    config(
        materialized='ephemeral'
    )
}}



select
    *,
    'one' as a_sample_column
from {{ ref('stg__customers_model') }}