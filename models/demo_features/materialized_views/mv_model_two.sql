{{ config(
    materialized = 'dynamic_table',
    snowflake_warehouse = 'TRANSFORMING',
    target_lag = '10000 minutes',
    on_configuration_change = 'apply',
    post_hook = "ALTER DYNAMIC TABLE {{this}} REFRESH;"
) }}


Select
*
from {{ ref('mv_model_one') }}