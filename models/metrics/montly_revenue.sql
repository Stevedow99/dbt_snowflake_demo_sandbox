Select
    *
from 
{{
metrics.calculate(
    metric('Revenue'),
    grain='month',
    dimensions=['region_name']
)

}}