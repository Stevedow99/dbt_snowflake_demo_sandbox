{{ 
    config(
        materialized='table',
        schema='spoc_converter_testing',
        alias='departments_final_salaries',
        meta={
            'input_sql_dialect': 'SnowSQL SQL',
            'input_stored_procedure_runner': 'Snowflake',
            'output_sql_dialect': 'Snowflake',
            'source_file_name': 'final-salaries-proc.sql'
        }
    )
}}

WITH source_data AS (
    SELECT 
        department_manager_id AS salary_employee_id
        ,CURRENT_DATE() AS salary_date
        ,5000.00 AS salary_amount
    FROM {{ ref('temp_departments') }}
)

SELECT * FROM source_data
