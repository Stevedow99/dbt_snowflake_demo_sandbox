{{
    config(
        materialized='table'
    )
}}


select  
       value as flatted_json_high_level, 
       loaded_at_datetime
from
    {{ source("sample_json_data", "sample_json_rawest_form_table") }},
    lateral flatten(input => raw_json_data)
