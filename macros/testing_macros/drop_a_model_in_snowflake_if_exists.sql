{%- macro drop_model_if_exists(model_name) -%}

    {# ----------------------------------------------------------------------------------------------- #}
    {# if the an execution happens and it's a run, build, or preview (rpc) we want to run our function #}
    {# ----------------------------------------------------------------------------------------------- #}

    {{log('================================================')}}
    {{log(' START MACRO ')}}
    {{log('================================================')}}

    {%- if execute -%}

        {# create a dict with all needed model info #}
        {%- set model_info = {'model_database': none, 'model_schema': none, 'model_identifier': none, 'model_materialization': none} -%}

        {# ----------------------------------------------------------------------------------------------- #}
        {# loop into the graph nodes and grab our model #}
        {# ----------------------------------------------------------------------------------------------- #}
        {%- for node in graph.nodes.values()      
            | selectattr("resource_type", "equalto", "model")
            | selectattr("name", "equalto", model_name) -%}

            {# up model info to whats in the graph object #}
            {%- do model_info.update({'model_database': node.database}) -%}
            {%- do model_info.update({'model_schema': node.schema}) -%}
            {%- do model_info.update({'model_identifier': node.name}) -%}
            {%- do model_info.update({'model_materialization': node.config.materialized}) -%}

        {%- endfor -%}

        {# ----------------------------------------------------------------------------------------------- #}
        {# if model doesn't exist we log it and set the outputted timestamp to 1900-01-01 #}
        {# ----------------------------------------------------------------------------------------------- #}
        {%- if model_info.model_identifier is none -%}

            {# log that the model doesn't exist #}
            {{ log("Model not found: " ~ model_name, info=True) }}

        {# ----------------------------------------------------------------------------------------------- #}
        {# if model does exist we query it for the max timestamp #}
        {# ----------------------------------------------------------------------------------------------- #}
        {%- else -%}

            {# log that the model exists #}
            {{ log("Model was found, it's relation is: " ~ model_info.model_database ~ "." ~ model_info.model_schema ~ "." ~ model_info.model_identifier ~ " and its of type " ~ model_info.model_materialization, info=True) }}

            {# create the query that we send down to the data warehouse #}
            {%- set sql_query -%}
                DROP {{ model_info.model_materialization }}
                {{ model_info.model_database }}.{{ model_info.model_schema }}.{{ model_info.model_identifier }}
            {%- endset -%}

            {# get the high watermark from the query #}
            {%- do run_query(sql_query).columns[0].values()[0] -%}

            {# log the model was frop #}
            {{ log("Model " ~ model_info.model_identifier ~ " was dropped from Snowflake", info=True) }}

        {%- endif -%}

    {{log('================================================')}}
    {{log(' END MACRO ')}}
    {{log('================================================')}}

    {%- endif -%}

{%- endmacro -%}
