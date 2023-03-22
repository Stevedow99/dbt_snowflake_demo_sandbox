{% snapshot orders_snapshot %}

{{
    config(
      target_database='STEVE_D_SANDBOX',
      target_schema='snap_shot_testing',
      unique_key='id',
      
      strategy='timestamp',
      updated_at='modified_timestamp',
      post_hook="{{snowflake_query_logging(this, audit_table_schema='audit_tables', audit_table_name = 'dbt_log_table')}}" 
    )
}}

select * from {{ ref('example_orders_table') }}

{% endsnapshot %}