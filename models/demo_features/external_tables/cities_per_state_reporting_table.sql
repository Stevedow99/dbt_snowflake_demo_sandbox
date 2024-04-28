{{
    config(
        materialized='table'
    )
}}


select
    State,
    count(*) as number_of_cities
from {{ ref('stg_snowflake_external_s3_stage__city_data') }}
group by State
order by number_of_cities desc