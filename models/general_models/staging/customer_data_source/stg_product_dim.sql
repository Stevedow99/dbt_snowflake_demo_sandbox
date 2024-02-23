with 

source as (

    select * from {{ source('customer_data_source', 'product_dim') }}

),

renamed as (

    select
        id as product_id,
        productname as vehicle_name,
        category as vehicle_category,
        color as vehicle_color,
        weight as vehicle_weight,
        dimensions as vehicle_dimensions,
        created_timestamp,
        modified_timestamp

    from source

)

select * from renamed