{% macro snowflake_query_logging(model_name, audit_table_schema='audit', audit_table_name = 'dbt_log_table') %}

{# ########################################################################## #}
{# setting the statement to grab the last query id for the model #}
{# if the resource was a snapshot we have to get the second to last query  #}
{# ########################################################################## #}


    {# if the resource was a snapshot and is already created we have to get the second to last query  #}
    {% if model.resource_type == 'snapshot' and adapter.get_relation(database, model.schema, model.name) != none %}

        {% call statement('last_query', fetch_result=True) -%}
            select last_query_id(-2) as last_query_id
        {%- endcall-%}  

    {# else we just get the last query  #}
    {% else %}

        {% call statement('last_query', fetch_result=True) -%}
            select last_query_id() as last_query_id
        {%- endcall-%}  

    {% endif %}


{# ########################################################################################################################## #}
{# if there is an execution of a run or build we pass run logging querys and create a table or insert into logging table #}
{# ########################################################################################################################## #}

    {% if execute and flags.WHICH in ['run','build'] %}

        {# grabbing the snowflake query id for the model run #}

        {%- set last_query_id = load_result('last_query')['data'][0][0] -%}

        {# checking #}

        {# creating the audit schema if it doesnt exist #}

        {%- call statement('create_audit_schema', fetch_result=False) -%}

            CREATE SCHEMA IF NOT EXISTS {{database}}.{{audit_table_schema}};

        {%- endcall -%}

        {# checking to see if the audit table exists #}

        {% set audit_table_exists = adapter.get_relation(database, audit_table_schema, audit_table_name) -%}


        {# ############################################################################# #}
        {# if the audit table doesnt exist we create it, else we insert the data into it #}
        {# ############################################################################# #}

        {% if audit_table_exists == none %}

            {# audit table doesnt exists so we create it for the first time #}

            {%- call statement('create_audit_table', fetch_result=False) -%}
                create or replace table {{database}}.{{audit_table_schema}}.{{audit_table_name}} ( dbt_model_name varchar(16777216), dbt_model_snowflake_location varchar(16777216), dbt_resource_type varchar(16777216), dbt_resource_path varchar(16777216), query_id varchar(16777216), query_text varchar(16777216), database_name varchar(16777216), schema_name varchar(16777216), query_type varchar(16777216), user_name varchar(16777216), role_name varchar(16777216), warehouse_name varchar(16777216), warehouse_size varchar(16777216), execution_status varchar(16777216), error_code number(38,0), error_message varchar(16777216), bytes_scanned number(38,0), rows_produced number(38,0), start_time timestamp_ltz(3), end_time timestamp_ltz(3), total_elapsed_time number(38,0) );
            {%- endcall -%}

            {{ log("Created a new audit table " ~ database ~ "." ~ schema ~ "_audit.dbt_log_table to track dbt models") }}

            {# audit table now exists so we insert data into it + log that we inserted data into it #}

            {%- call statement('insert_into_audit_table', fetch_result=False) -%}
                insert into {{database}}.{{audit_table_schema}}.{{audit_table_name}} (select '{{this.table}}' as dbt_model_name, '{{model_name}}' as dbt_model_snowflake_location, '{{model.resource_type}}' as dbt_resource_type, '{{model.path}}' as dbt_resource_path, query_id, query_text, database_name, schema_name, query_type, user_name, role_name, warehouse_name, warehouse_size,execution_status, error_code, error_message, BYTES_SCANNED, ROWS_PRODUCED, start_time, end_time, total_elapsed_time from table(information_schema.query_history()) where query_id = '{{ last_query_id }}' )
            {%- endcall -%}

            {{ log("Inserted a logged run into the audit table " ~ database ~ "." ~ schema ~ "_audit.dbt_log_table") }}

        {% else %}

            {# audit table already exists so we insert data into it + log that we inserted data into it #}

            {%- call statement('insert_into_audit_table', fetch_result=False) -%}
                insert into {{database}}.{{audit_table_schema}}.{{audit_table_name}} (select '{{this.table}}' as dbt_model_name, '{{model_name}}' as dbt_model_snowflake_location, '{{model.resource_type}}' as dbt_resource_type, '{{model.path}}' as dbt_resource_path, query_id, query_text, database_name, schema_name, query_type, user_name, role_name, warehouse_name, warehouse_size,execution_status, error_code, error_message, BYTES_SCANNED, ROWS_PRODUCED, start_time, end_time, total_elapsed_time from table(information_schema.query_history()) where query_id = '{{ last_query_id }}' )
            {%- endcall -%}

            {{ log("Inserted a logged run into the audit table " ~ database ~ "." ~ schema ~ "_audit.dbt_log_table") }}

        {% endif %}

    {% endif %}

{% endmacro %}
