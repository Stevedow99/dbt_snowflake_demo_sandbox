{{
    config(
        materialized='table',
        pre_hook = 'CALL SYSTEM$WAIT(25)'

    )
}}

select * from 
{{ ref('an_example_model') }}