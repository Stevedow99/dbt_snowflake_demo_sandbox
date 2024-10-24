{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {% set model_path = node.path %}
    
    {%- if custom_schema_name is none and 'marts' in model_path.split('/') -%}

        GOLD

    {%- elif custom_schema_name is none and 'transform' in model_path.split('/')-%}

        SILVER

    {%- elif custom_schema_name is none and 'staging' in model_path.split('/')-%}

        BRONZE

    {%- elif custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}