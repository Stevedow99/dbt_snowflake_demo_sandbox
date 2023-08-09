Select
    *
from 
{{
metrics.calculate(
    metric('net_profit'),
    grain='month',
    dimensions=['region_name']
)

}}