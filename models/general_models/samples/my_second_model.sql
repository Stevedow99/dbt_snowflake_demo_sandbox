

Select 
    *,
    1 as one,
    2 as two
from {{ ref('my_first_model') }}