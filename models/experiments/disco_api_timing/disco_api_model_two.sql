{{
    config(
        materialized='table',
        pre_hook=["CALL SYSTEM$WAIT(10, 'MINUTES')"]
    )
}}



select * from {{ ref('disco_api_model_one') }}