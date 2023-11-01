{{
    config(
        materialized='table',
        pre_hook='CREATE OR REPLACE SEQUENCE seq2'
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
    table(getnextval(seq2)) seq