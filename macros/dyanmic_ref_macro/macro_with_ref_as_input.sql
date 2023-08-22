{% macro macro_with_ref_as_input(model_to_ref, third_column_value) %}

    select 
        *,
        '{{ third_column_value }}' as third_column
    from {{ model_to_ref }}

{% endmacro %}