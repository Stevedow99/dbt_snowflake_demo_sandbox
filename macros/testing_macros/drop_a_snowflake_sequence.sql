{% macro drop_a_snowflake_sequence(sequence_name='example_orders_table') -%}

  
    {% set query %}
        DROP SEQUENCE {{ sequence_name }}
    {% endset %}

    {% do run_query(query) %}


{%- endmacro %}