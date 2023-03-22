select
*
from {{ ref('example_orders_table') }}

UNION ALL

select
*
from {{ ref('snowflake_logging_example_snapshot') }}