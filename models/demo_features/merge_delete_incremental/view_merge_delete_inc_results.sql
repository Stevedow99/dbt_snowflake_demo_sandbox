


Select
*
from
{{ ref('merge_delete_incremental_table') }}


-- compare ids
Select
a.id as target_id,
b.id as source_id
from {{ ref('merge_delete_incremental_table') }} a
FULL OUTER JOIN {{ source('sample_data', 'example_orders_table_two') }} b
    on a.id = b.id