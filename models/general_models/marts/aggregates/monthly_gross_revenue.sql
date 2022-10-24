{{
    config(
        materialized='table',
        enabled= false,
        post_hook = [
            "{{snowflake_query_logging(this)}}",
            validate_model(this)
        ]
    )
}}


select
    date_trunc(month, order_date) as order_month,
    REGION_NAME,
    sum(gross_item_sales_amount) as gross_revenue

from {{ ref('fct_order_items') }}
    group by 
        order_month,
        REGION_NAME
    order by 
        order_month,
        REGION_NAME
