{{
    config(
        materialized='incremental',
        unique_key='id'
    )
}}

    id,
    one,
    varchar_column,
    modified_datetime

from {{ ref('upstream_model_one') }}

{% if is_incremental() %}


  where modified_datetime > (select max(modified_datetime) from {{ this }})

{% endif %}