{% macro delete_row_to_example_orders_table(orders_table_name='example_orders_table') -%}

  
    {% set query %}
        DELETE FROM  {{target.database}}.dbtsandbox_sdowling.{{orders_table_name}} 
        WHERE 
        select id = (SELECT id from {{target.database}}.dbtsandbox_sdowling.{{orders_table_name}} order by created_timestamp limit 1)
    {% endset %}

        {% do run_query(query) %}

    {% endif %}

{%- endmacro %}