

Select 
    *,
    uniform(1, 100000, random()) as random_number
from {{ ref('my_first_model') }}