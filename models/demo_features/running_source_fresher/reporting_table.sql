{{
    config(
        materialized='table',
        tags=["customer_data"]
    )
}}



Select 
*
from {{ ref('sample_incremental_model_one') }}

UNION ALL

Select
*
from {{ ref('sample_incremental_model_two') }}