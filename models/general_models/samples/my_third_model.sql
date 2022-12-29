Select
*,
1 as one,
2 as two
from {{ ref('my_second_model') }}