{% snapshot orders_snapshot %}

{{
    config(
      target_database='STEVE_D_SANDBOX',
      target_schema='snap_shot_testing',
      unique_key='id',
      
      strategy='timestamp',
      updated_at='modified_timestamp',
    )
}}

select * from {{ ref('example_orders_table') }}

{% endsnapshot %}


