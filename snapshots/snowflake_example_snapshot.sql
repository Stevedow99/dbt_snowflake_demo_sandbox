{% snapshot orders_snapshot_test %}

{#-- Check if the snapshot table exists --#}
{% set does_snap_shot_exist = not adapter.get_relation(this.database, this.schema, this.table) %}

{{
    config(
      target_database='STEVE_D_SANDBOX',
      target_schema='snap_shot_testing',
      unique_key='id',
      strategy='timestamp',
      updated_at='modified_timestamp',
    )
}}


{% if does_snap_shot_exist %}
    -- Logic for the running if the snapshot doesn't exist

    select
        *
    from {{ ref('example_orders_table') }}

{% else %}
    -- Logic for subsequent runs

    with new as (
        select id, status, order_value, created_timestamp, modified_timestamp
        from {{ ref('example_orders_table') }}
    ),

    current_data_overlap as (
        select
            n.id, 
            n.status,
            (n.order_value + c.order_value) as order_value,
            n.created_timestamp,
            n.modified_timestamp
        from new n
            left join {{ this }} c
                on c.id = n.id 
                )

    select * from current_data_overlap

{% endif %}

{% endsnapshot %}