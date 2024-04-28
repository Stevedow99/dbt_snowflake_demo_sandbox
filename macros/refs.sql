{% macro default__log_input(input_message) %}

    {{ 'project' }}

{% endmacro %}



{%- macro log_input(input_message) -%}
    {{ return(adapter.dispatch('log_input', 'dbt_snowflake_demo_sandbox')(input_message)) }}
{% endmacro %}