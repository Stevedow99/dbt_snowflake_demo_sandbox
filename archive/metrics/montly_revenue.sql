Select
    *
from 
{{
metrics.calculate(
    metric('revenue'),
    grain='month',
    dimensions=['region_name']
)

}}