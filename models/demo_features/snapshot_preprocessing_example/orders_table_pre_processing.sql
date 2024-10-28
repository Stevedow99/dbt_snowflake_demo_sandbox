
{{ config(materialized='ephemeral') }}




with 

source as (

    select * from {{ source('sample_data', 'example_orders_table') }}

),

renamed as (

    select
        id,
        status,
        created_timestamp,
        modified_timestamp,
        order_value,
        CASE 
            WHEN order_value < 0 THEN 'return'
            WHEN order_value < 200 THEN 'small order'
            WHEN order_value < 500 THEN 'medium order'
            ELSE 'large order'
        END AS order_type


    from source

)

select * from renamed
