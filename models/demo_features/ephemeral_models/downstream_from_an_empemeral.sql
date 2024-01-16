{{
    config(
        materialized='table'
    )
}}

Select 
    * 
from {{ ref('a_sample_ephemeral_model_one') }}