{{
    config(
        materialized='incremental',
        pre_hook='CREATE SEQUENCE IF NOT EXISTS seq1'
    )
}}

select
  seq.nextval as sequence_of_numbers,
  tab.id,
  tab.status,
  tab.created_timestamp,
  tab.modified_timestamp
  
from 
    {{ source('sample_data', 'example_orders_table') }} tab,
    table(getnextval(seq1)) seq

{% if is_incremental() %}

  where modified_timestamp > (select max(modified_timestamp) from {{ this }})

{% endif %}