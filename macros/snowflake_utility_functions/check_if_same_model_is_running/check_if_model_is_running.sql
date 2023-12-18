{%- macro check_if_model_is_running(query_tag_to_check, polling_period_in_seconds, number_of_times_to_check=150) -%}


    {%- set get_running_queries_with_tag -%}

        SELECT
            count(*)
        FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
        where EXECUTION_STATUS = 'RUNNING' and query_text not like 'CALL SYSTEM$WAIT%' and QUERY_TAG ='{{query_tag_to_check}}'

    {%- endset -%}

    {%- set results = run_query(get_running_queries_with_tag) -%}

    {%- if execute -%}

        {%- set number_of_queries_running = results.columns[0].values()[0] -%}

        {%- for _ in range(0, number_of_times_to_check) -%}
            
            {%- if number_of_queries_running > 0 -%}

                {{ log("There is currently processes running with the query tag " ~ query_tag_to_check) }}
                {{ log("waiting " ~ polling_period_in_seconds ~ " seconds and then checking again "  ) }}
                
                {%- do run_query( 'CALL SYSTEM$WAIT(' ~ polling_period_in_seconds ~ ')') -%}
                
            {%- else -%}

                {{ log("No processes running with the query tag " ~ query_tag_to_check ) }}
                {{ log("Kicking off the current model since nothing is running concurrently" ) }}

                {%- break -%}

            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

{%- endmacro -%}