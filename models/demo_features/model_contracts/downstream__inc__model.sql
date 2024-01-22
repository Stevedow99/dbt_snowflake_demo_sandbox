{{
    config(
        materialized='incremental',
        unique_key='id',
        on_schema_change='append_new_columns'
    )
}}

select

    id,
    one,
    varchar_column,
    modified_datetime

from {{ ref('upstream_model_one') }}

{% if is_incremental() %}


  where modified_datetime > (select max(modified_datetime) from {{ this }})

{% endif %}


