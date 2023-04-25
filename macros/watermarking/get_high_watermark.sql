{%- macro get_high_watermark(model_name, timestamp_column) -%}

    {# ----------------------------------------------------------------------------------------------- #}
    {# if the an execution happens and it's a run, build, or preview (rpc) we want to run our function #}
    {# ----------------------------------------------------------------------------------------------- #}

    {%- if execute and flags.WHICH in ['run', 'build', 'rpc']-%}

        {# create a dict with all needed model info #}
        {%- set model_info = {'model_database': none, 'model_schema': none, model_identifier: none} -%}

        {# ----------------------------------------------------------------------------------------------- #}
        {# loop thru the graph nodes and grab our model #}
        {# ----------------------------------------------------------------------------------------------- #}
        {%- for node in graph.nodes.values()      
            | selectattr("resource_type", "equalto", "model")
            | selectattr("name", "equalto", model_name) -%}

            {# up model info to whats in the graph object #}
            {%- do model_info.update({'model_database': node.database}) -%}
            {%- do model_info.update({'model_schema': node.schema}) -%}
            {%- do model_info.update({'model_identifier': node.name}) -%}

        {%- endfor -%}

        {# ----------------------------------------------------------------------------------------------- #}
        {# if model doesn't exist we log it and set the outputted timestamp to 1900-01-01 #}
        {# ----------------------------------------------------------------------------------------------- #}
        {%- if model_info.model_identifier is none -%}

            {# log that the model doesn't exist #}
            {{ log("Model not found: " ~ model_name, info=True) }}

            {# set the output to  1900-01-01 in datetime stamp #}
            {{'1900-01-01::DATETIME'}}

        {# ----------------------------------------------------------------------------------------------- #}
        {# if model does exist we query it for the max timestamp #}
        {# ----------------------------------------------------------------------------------------------- #}
        {%- else -%}

            {# create the query that we send down to the data warehouse #}
            {%- set sql_query -%}
                SELECT
                COALESCE(MAX({{ timestamp_column }}), '1900-01-01') as high_watermark
                FROM {{ model_info.model_database }}.{{ model_info.model_schema }}.{{ model_info.model_identifier }}
            {%- endset -%}

            {# get the high watermark from the query #}
            {%- set high_watermark = run_query(sql_query).columns[0].values()[0] -%}

            {# return the high watermark as a datetime stamp #}
            {{ "'" ~ high_watermark ~ "'" ~ '::DATETIME'}}
            
        {%- endif -%}

    {%- endif -%}
{%- endmacro -%}
