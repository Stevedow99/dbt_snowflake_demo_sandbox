

with source as (

    select * from {{ source('customer_data_source', 'purchases_fct') }}

),final as (

    select
        id as transaction_id,
        customer_id,
        product_id,
        salesrep_id,
        amount as transaction_amount,
        purchase_datetime,
        created_timestamp,
        modified_timestamp
    from source

)

select * from final
