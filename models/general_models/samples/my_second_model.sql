

Select 
    *,
    2 as two,
    3 as three,
    4 as four,
    5 as five
from {{ ref('my_first_model') }}