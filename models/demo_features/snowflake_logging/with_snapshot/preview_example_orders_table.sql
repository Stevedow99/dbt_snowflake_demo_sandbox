with table_a as (

select
*
from {{ ref('example_orders_table') }} ),

with table_b as (


select * from 
{{ ref('orders_snapshot') }} )


Select * from table_a