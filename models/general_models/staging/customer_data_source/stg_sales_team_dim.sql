with 

source as (

    select * from {{ source('customer_data_source', 'salesteam_dim') }}

),

renamed as (

    select
        salesrepid as salesrep_id,
        salesrepname salesrep_name,
        firstday as salesrep_start_date,
        trainedinnewsales as is_trained_in_new_sales_program,
        region as salesrep_region,
        email as salesrep_email,
        created_timestamp,
        modified_timestamp

    from source

)

select * from renamed