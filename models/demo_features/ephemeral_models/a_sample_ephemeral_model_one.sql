{{
    config(
        materialized='ephemeral'
    )
}}



select
    *,
    null as a_sample_column
from {{ ref('stg__customers_model') }}