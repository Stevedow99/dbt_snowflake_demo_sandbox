{{
    config(
        materialized='table'
    )
}}

Select 
123456789 as id,
'pending' as status,
current_timestamp() as created_timestamp,
current_timestamp() as modified_timestamp