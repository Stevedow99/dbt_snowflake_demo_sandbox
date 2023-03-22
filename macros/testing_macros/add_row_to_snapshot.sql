{% macro add_row_to_snapshot() -%}

  {% set query %}
    INSERT INTO  STEVE_D_SANDBOX.dbtsandbox_sdowling.example_orders_table (
    select
        uniform(1, 100000, random()) as id,
        'pending' as status,
        current_timestamp() as created_timestamp,
        current_timestamp() as modified_timestamp
        )
  {% endset %}

  {% do run_query(query) %}

{%- endmacro %}