{% macro add_row_to_example_orders_table(orders_table_name='example_orders_table', default_schema_name='dbtsandbox_sdowling') -%}

  {% set table_exists_query %}

    Select count(*) as table_existis from (
    Select * from {{target.database}}.INFORMATION_SCHEMA.TABLES where lower(table_name) = '{{orders_table_name}}' and lower(TABLE_SCHEMA) = '{{default_schema_name}}')

  {% endset %}


  {%- set does_table_exists = run_query(table_exists_query).columns[0].values()[0] -%}

    {% if does_table_exists == 0 %}

        {% set ct_query %}

        CREATE TABLE {{target.database}}.{{default_schema_name}}.{{orders_table_name}} as (
        select
            uniform(1, 100000, random()) as id,
            'pending' as status,
            current_timestamp() as created_timestamp,
            current_timestamp() as modified_timestamp
            )
        {% endset %}

        {% do run_query(ct_query) %}


    {% else %}

        {% set query %}
        INSERT INTO  {{target.database}}.{{default_schema_name}}.{{orders_table_name}} (
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