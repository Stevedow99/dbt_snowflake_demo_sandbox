{{ 
    config(
        materialized='table',
        schema='spoc_converter_testing',
        alias='temp_departments',
        meta={
            'input_sql_dialect': 'SnowSQL',
            'input_stored_procedure_runner': 'Snowflake',
            'output_sql_dialect': 'Snowflake',
            'source_file_name': 'temp_departments_model.sql'
        }
    )
}}

WITH source_data AS (
    SELECT
        employee_id AS department_manager_id,
        RPAD('Department', 20, ' ') AS department_name,
        -- NOTE: original function for reference - RPAD('Department', 20, ' ') AS department_name
        employee_id AS manager_id,
        1 AS location_id
    FROM {{ ref('temp_employees') }}
)

SELECT * FROM source_data

/*
Conversion Logic:
1. The `materialized`, `schema`, and `alias` config options are validated and kept.
2. Non-standard config options are moved to the `meta` dictionary.
3. The `RPAD` function is retained as it is compatible with Snowflake.
4. The table reference is changed to use the `ref` function, assuming 'temp_employees' is another dbt model.
5. Trailing commas are used in the SELECT statement, respecting the original format.
6. Comments are added to retain the original function for reference.
*/