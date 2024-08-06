{{
    config(
        materialized='table',
        schema='spoc_converter_testing',
        alias='temp_employees',
        meta={
            'input_sql_dialect': 'SnowSQL SQL',
            'input_stored_procedure_runner': 'Snowflake',
            'output_sql_dialect': 'Snowflake',
            'source_file_name': 'create_temp_and_real_tables_proc.sql'
        }
    )
}}

WITH temp_employees AS (
    SELECT 
        SEQ8() AS employee_id
        ,RPAD('First', 10, ' ') AS first_name
        -- NOTE: original function for reference - RPAD('First', 10, ' ')
        ,RPAD('Last', 10, ' ') AS last_name
        -- NOTE: original function for reference - RPAD('Last', 10, ' ')
        ,RPAD('email@example.com', 20, ' ') AS email
        -- NOTE: original function for reference - RPAD('email@example.com', 20, ' ')
        ,RPAD('123-456-7890', 12, ' ') AS phone_number
        -- NOTE: original function for reference - RPAD('123-456-7890', 12, ' ')
        ,CURRENT_DATE() AS hire_date
        -- NOTE: original function for reference - CURRENT_DATE()
        ,RPAD('Job', 10, ' ') AS job_id
        -- NOTE: original function for reference - RPAD('Job', 10, ' ')
        ,1000.00 AS salary
        ,0.10 AS commission_pct
        ,NULL AS manager_id
        ,1 AS department_id
    FROM TABLE(GENERATOR(ROWCOUNT => 10))
)

SELECT * FROM temp_employees

/* 
Conversion Logic:
1. The `materialized`, `schema`, and `alias` config options are validated and kept.
2. The stored procedure logic is converted to a dbt model, with the main query logic placed in the WITH clause.
3. The `RPAD`, `CURRENT_DATE`, and `SEQ8` functions are retained as they are compatible with Snowflake.
4. Table references are directly incorporated into the model without using the `ref` function, as they are part of the query generation.
5. Comments are added to retain the original function for reference.
6. Leading commas are used in the SELECT statement to retain the original format.
*/
