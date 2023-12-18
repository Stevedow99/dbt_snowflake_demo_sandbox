{{
    config(
        materialized='table',
        query_tag = 'running_example_model',
        pre_hook = ["{{ check_if_model_is_running (query_tag_to_check='running_example_model', polling_period_in_seconds = 20) }}"]

    )
}}

-- just some dummy code to help me test the solution
with table_wait as (

    -- select SYSTEM$WAIT({{var('testing_wait_seconds')}}) as wait_time 
    select SYSTEM$WAIT(15) as wait_time 
    
) 

select 1 as one