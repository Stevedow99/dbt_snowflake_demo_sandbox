{{
    config(
        materialized='table'
    )
}}


select
    date_trunc(month, order_date) as order_month,
    region_name,
    sum(gross_item_sales_amount - SUPPLIER_COST) as net_profit

from {{ ref("fct_order_items") }}
group by order_month, region_name
order by order_month, region_name
