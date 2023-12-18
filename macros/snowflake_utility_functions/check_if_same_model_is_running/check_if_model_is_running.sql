{%- macro check_if_model_is_running(query_tag_to_check, polling_period_in_seconds, number_of_times_to_check=150) -%}


    {# ---------------------------------------------------------------------------------------------------------------- #}
    {# creating a query to get running processes with the given query tag #}
    {# filtering out any metadata queries  #}
    {# ---------------------------------------------------------------------------------------------------------------- #}
    {%- set get_running_queries_with_tag -%}

        SELECT 'MARCO QUERY' as type,
            count(*) as processes_running
        FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
        where EXECUTION_STATUS = 'RUNNING' 
              and query_text not like 'CALL SYSTEM$WAIT%' 
              and query_text not like '%MARCO QUERY%' 
              and QUERY_TAG ='{{query_tag_to_check}}'

    {%- endset -%}


    {# ------------------------------------------------------------------------------------------------------------------------------------------- #}
    {# creating a jinja while loop to sleep in snowflake until the pre host confirms there are no other running queries with the specfied tag #}
    {# ------------------------------------------------------------------------------------------------------------------------------------------- #}


    {%- if execute -%}

        {# jinja while loop syntax (ranged for loop) #}
        {%- for _ in range(0, number_of_times_to_check) -%}

            {# running the query to check for running processes with query tag #}
            {%- set results = run_query(get_running_queries_with_tag) -%}

            {# running the query to check for running processes with query tag #}
            {%- set number_of_queries_running = results.columns[1].values() -%}
            
            {# if there is a process running with the query tag we log it #}
            {%- if number_of_queries_running[0] > 0 -%}

                {# doing some logging #}
                {{ log("There is currently processes running with the query tag " ~ query_tag_to_check) }}
                {{ log("waiting " ~ polling_period_in_seconds ~ " seconds and then checking again "  ) }}
                {{ log("There are " ~ number_of_queries_running[0] ~ " processes running")}}
                
                {# we run a sleep in snowflake for the specfied number of seconds #}
                {%- do run_query( 'CALL SYSTEM$WAIT(' ~ polling_period_in_seconds ~ ')') -%}
                
            {# if no processes are running we break the loop #}    
            {%- else -%}

                {# doing some logging #}
                {{ log("No processes running with the query tag " ~ query_tag_to_check ) }}
                {{ log("Kicking off the current model since nothing is running concurrently" ) }}

                {%- break -%}

            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

{%- endmacro -%}