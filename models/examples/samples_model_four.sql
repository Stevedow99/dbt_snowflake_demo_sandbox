Select 
*
from {{ ref('samples_model_three') }}

UNION ALL

Select 
* 
from {{ ref('a_random_model') }}