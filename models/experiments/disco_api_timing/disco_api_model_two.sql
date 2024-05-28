{{
    config(
        materialized='table',
        pre_hook=["CALL SYSTEM$WAIT(1, 'MINUTES')"]
    )
}}



select * from {{ ref('disco_api_model_one') }}