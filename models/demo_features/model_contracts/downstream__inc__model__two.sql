{{
    config(
        materialized='incremental',
        unique_key='id',
        on_schema_change='fail'
    )
}}

select

    id,
    one,
    varchar_column,
    modified_datetime

from {{ ref('upstream_model_two') }}

{% if is_incremental() %}


  where modified_datetime > (select max(modified_datetime) from {{ this }})

{% endif %}


