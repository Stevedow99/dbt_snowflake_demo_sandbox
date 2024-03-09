{{ config(
    materialized = 'dynamic_table',
    snowflake_warehouse = 'TRANSFORMING',
    target_lag = '100000 minutes',
    on_configuration_change = 'apply',
    post_hook = "ALTER DYNAMIC TABLE {{this}} REFRESH;"
) }}


Select
*
from
{{ source('sample_data', 'example_orders_table_two') }}