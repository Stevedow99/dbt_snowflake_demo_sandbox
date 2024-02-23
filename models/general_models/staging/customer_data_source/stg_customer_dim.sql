

with source as (

    select * from {{ source('customer_data_source', 'customer_dim') }}

),final as (

    select
        id as customer_id,
        gender,
        birthdate,
        maiden_name,
        lname,
        fname,
        address,
        city,
        state,
        zip,
        phone,
        email,
        cc_type,
        cc_number,
        cc_cvc,
        customer_join_date,
        created_timestamp,
        modified_timestamp
    from source

)

select * from final
