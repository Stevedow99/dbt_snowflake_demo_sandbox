{% macro add_row_to_example_orders_table(orders_table_name='example_orders_table') -%}

  {% set table_exists_query %}

    Select count(*) as table_existis from (
    Select * from {{target.database}}.INFORMATION_SCHEMA.TABLES where lower(table_name) = '{{orders_table_name}}')

  {% endset %}


  {%- set does_table_exists = run_query(table_exists_query).columns[0].values()[0] -%}

  {% if does_table_exists == 0 %}

    CREATE TABLE {{target.database}}.dbtsandbox_sdowling.{{orders_table_name}} as (
    select
        uniform(1, 100000, random()) as id,
        'pending' as status,
        current_timestamp() as created_timestamp,
        current_timestamp() as modified_timestamp
        )

    {% else %}

        {% set query %}
        INSERT INTO  {{target.database}}.dbtsandbox_sdowling.{{orders_table_name}} (
        select
            uniform(1, 100000, random()) as id,
            'pending' as status,
            current_timestamp() as created_timestamp,
            current_timestamp() as modified_timestamp
            )
        {% endset %}

        {% do run_query(query) %}

    {% endif %}

{%- endmacro %}