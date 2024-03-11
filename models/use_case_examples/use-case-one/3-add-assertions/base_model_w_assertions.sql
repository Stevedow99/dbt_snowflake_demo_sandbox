{{
    config(
        materialized='ephemeral'
    )
}}


with base_model_with_assertions as (
     Select
        *,
        {{ dbt_assertions.assertions() | indent(4) }}
    from {{ ref('staging_model_base') }}
)

select * from base_model_with_assertions