

Select 
MAX(MODIFIED_TIMESTAMP) as max_timestamp,
'SOURCE: Example orders table' as object
from {{ source('sample_data', 'example_orders_table') }} 

UNION


Select 
MAX(MODIFIED_TIMESTAMP) as max_timestamp,
'SOURCE: model b' as object
from {{ ref('model_mw_b') }}
