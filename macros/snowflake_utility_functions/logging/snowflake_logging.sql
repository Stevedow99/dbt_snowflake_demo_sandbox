{% macro snowflake_query_logging(model_name) %}

{# #################################################################### #}
{# setting the statement to grab the last query id for the model #}
{# #################################################################### #}

    {% call statement('last_query', fetch_result=True) -%}
        select last_query_id() as last_query_id
    {%- endcall-%}  


{# ########################################################################################################################## #}
{# if there is an execution of a run or build we pass run logging querys and create a table or insert into logging table #}
{# ########################################################################################################################## #}

    {% if execute and flags.WHICH in ['run','build'] %}

        {# grabbing the snowflake query id for the model run #}

        {%- set last_query_id = load_result('last_query')['data'][0][0] -%}

        {# creating the audit schema if it doesnt exist #}

        {%- call statement('create_audit_schema', fetch_result=False) -%}

            CREATE SCHEMA IF NOT EXISTS {{database}}.{{schema}}_audit;

        {%- endcall -%}

        {# checking to see if the audit table exists #}

        {% set audit_table_exists = adapter.get_relation(database, schema ~ '_audit', 'dbt_log_table') -%}


        {# ############################################################################# #}
        {# if the audit table doesnt exist we create it, else we insert the data into it #}
        {# ############################################################################# #}

        {% if audit_table_exists == none %}

            {# audit table doesnt exists so we create it for the first time with data from the run + log that we created one #}

            {%- call statement('create_audit_table', fetch_result=False) -%}
                create or replace table {{database}}.{{schema}}_audit.dbt_log_table as (select '{{this.table}}' as dbt_model_name, '{{model_name}}' as dbt_model_snowflake_location, query_id, query_text, database_name, schema_name, query_type, user_name, role_name, warehouse_name, warehouse_size,execution_status, error_code, error_message, BYTES_SCANNED, ROWS_PRODUCED, start_time, end_time, total_elapsed_time from table(information_schema.query_history()) where query_id = '{{ last_query_id }}' )
            {%- endcall -%}

            {{ log("Created a new audit table " ~ database ~ "." ~ schema ~ "_audit.dbt_log_table to track dbt models") }}

        {% else %}

            {# audit table already exists so we insert data into it + log that we inserted data into it #}

            {%- call statement('insert_into_audit_table', fetch_result=False) -%}
                insert into {{database}}.{{schema}}_audit.dbt_log_table (select '{{this.table}}' as dbt_model_name, '{{model_name}}' as dbt_model_snowflake_location, query_id, query_text, database_name, schema_name, query_type, user_name, role_name, warehouse_name, warehouse_size,execution_status, error_code, error_message, BYTES_SCANNED, ROWS_PRODUCED, start_time, end_time, total_elapsed_time from table(information_schema.query_history()) where query_id = '{{ last_query_id }}' )
            {%- endcall -%}

            {{ log("Inserted a logged run into the audit table " ~ database ~ "." ~ schema ~ "_audit.dbt_log_table") }}

        {% endif %}

    {% endif %}

{% endmacro %}
