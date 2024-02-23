{{
    config(
        materialized='view'
    )
}}    
    
select 
        *,
        SPLIT_PART(email, '@', 2) as email_top_level_domain
    
     from {{ ref('stg_customer_dim') }}