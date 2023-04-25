{{
    config(
        materialized='table'
    )
}}


select
* 
from {{ ref('model_mw_a') }}