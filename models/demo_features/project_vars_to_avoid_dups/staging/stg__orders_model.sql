select

*

from {{ source('sample_data', 'example_orders_table') }}
