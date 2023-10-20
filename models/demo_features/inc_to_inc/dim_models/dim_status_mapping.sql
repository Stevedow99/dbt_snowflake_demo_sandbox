{{
    config(
        materialized='table'
    )
}}

Select
    *
from {{ ref('status_mapping_seed') }}