

Select 
    *,
    2 as two,
    3 as three,
    4 as four
from {{ ref('my_first_model') }}