{{
    config(
        materialized='incremental',
        unique_key='id'
    )
}}


with orders_table_one as (
    select
        id,
        status,
        modified_timestamp as table_one_modified_timestamp,
        null as table_two_modified_timestamp
    
    from {{ ref('incremental_model_one') }}

    {% if is_incremental() %}

        where modified_timestamp > (select max(table_one_modified_timestamp) from {{ this }})

    {% endif %}

),

orders_table_two as (

    select
        id,
        status,
        null as table_one_modified_timestamp,
        modified_timestamp as table_two_modified_timestamp
    
    from {{ ref('incremental_model_two') }}

    {% if is_incremental() %}

        where modified_timestamp > (select max(table_two_modified_timestamp) from {{ this }})

    {% endif %}

),

combined_orders as (
    select 
        *
    from orders_table_one
    union
    select 
        *
    from orders_table_two
),

combined_orders_w_dim as (
    select 
        o.*,
        d.status_code as order_status_code
    from combined_orders o
        left join {{ ref('dim_status_mapping') }} d
            on o.status = d.status
)



Select 
    id,
    status,
    order_status_code,
    current_timestamp() AS upstream_modified_timestamp,
    table_one_modified_timestamp,
    table_two_modified_timestamp
from combined_orders_w_dim

-- I don't need an incremental clause here because in the way that I get data it's natually incremental 
-- You could also just have one upstream table data by taking the lowest of the X number of tables coming in and upserting every time but i prefer to have the metadata feilds