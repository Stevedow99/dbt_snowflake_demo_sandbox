{{
    config(
        materialized='table',
        query_tag = 'running_example_model',
        pre_hook = 'CALL SYSTEM$WAIT(25)'

    )
}}


select 1 as one 