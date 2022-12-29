select
  order_month,
  {{ dbt_utils.pivot(
      column='region_name',
      values=dbt_utils.get_column_values(ref('monthly_gross_revenue_metrics'), 'region_name'),
      then_value='gross_revenue'

  ) }}
from {{ ref('monthly_gross_revenue_metrics') }}
group by order_month