{{
    config(
        materialized='table'
    )
}}


select
    '1' as id,
    1 as one,
    '123' as varchar_column,
    current_timestamp() as modified_datetime

UNION ALL

select
    '2' as id,
    1 as one,
    '1234' as varchar_column,
    current_timestamp() as modified_datetime