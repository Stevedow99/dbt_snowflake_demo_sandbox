{{
    config(
        materialized='table',
        enabled= True,
        post_hook = [
            "{{snowflake_query_logging(this, audit_table_schema='audit_tables', audit_table_name = 'dbt_log_table')}}"
        ]
    )
}}


select
    date_trunc(month, order_date) as order_month,
    sum(gross_item_sales_amount) as gross_revenue

from {{ ref('fct_order_items') }}
    group by 
        order_month
    order by 
        order_month

