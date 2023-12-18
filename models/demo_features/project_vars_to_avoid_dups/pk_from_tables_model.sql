{{
    config(
        materialized='incremental',
        unique_key='id'
    )
}}



-- this model uses the followings models
-- {{ ref('orders') }}
-- {{ ref('customers') }}
-- {{ ref('products') }}



with orders_pks as (

    {% if var('dbt_cloud_job_name') == 'orders_job' %}

        select
        'orders' || id as id,
        id as orders_primiary_key,
        null as customers_primiary_key,
        null as product_primiary_key,
        modified_timestamp as orders_modified_timestamp,
        null as customers_modified_timestamp,
        null as product_modified_timestamp
        
        from {{ ref('orders') }}

        {% if is_incremental() %}

            where modified_timestamp > (select ifnull(max(orders_modified_timestamp), to_date('1800-01-01')) from {{ this }})

        {% endif %}

    {% else %}

        select 1

    {% endif %}


),

customers_pks as (

    {% if var('dbt_cloud_job_name') == 'customers_job' %}

        select
        'customers' || id as id,
        null as orders_primiary_key,
        id as customers_primiary_key,
        null as product_primiary_key,
        null as orders_modified_timestamp,
        modified_timestamp as customers_modified_timestamp,
        null as product_modified_timestamp
        
        from {{ ref('customers') }}

        {% if is_incremental() %}

            where modified_timestamp > (select ifnull(max(customers_modified_timestamp), to_date('1800-01-01')) from {{ this }})

        {% endif %}

    {% else %}

        select 1

    {% endif %}

),

product_pks as (

    {% if var('dbt_cloud_job_name') == 'products_job' %}

        select
        'products' || id as id,
        null as orders_primiary_key,
        null as customers_primiary_key,
        id as product_primiary_key,
        null as orders_modified_timestamp,
        null as customers_modified_timestamp,
        modified_timestamp as product_modified_timestamp
        
        from {{ ref('products') }}

        {% if is_incremental() %}

            where modified_timestamp > (select ifnull(max(product_modified_timestamp), to_date('1800-01-01')) from {{ this }})

        {% endif %}

    {% else %}

        select 1

    {% endif %}

)


{% if var('dbt_cloud_job_name') == 'orders_job' %}
    Select * from orders_pks
{% elif var('dbt_cloud_job_name') == 'customers_job' %}
    Select * from customers_pks
{% elif var('dbt_cloud_job_name') == 'products_job' %}
    Select * from product_pks
{% endif %}