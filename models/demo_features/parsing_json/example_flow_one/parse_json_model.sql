{{
    config(
        materialized='table'
    )
}}



  SELECT
    flatted_json_high_level:_id::number as _id,
    flatted_json_high_level:propertyManager:person:name::string as propertymanager_name,
    flatted_json_high_level:propertyManager:person:company:name::string as company,
    value:method::string as contact_method,
    value:value::string as contact_value,
    LOADED_AT_DATETIME
  FROM
    {{ ref('flatten_json_model') }},
    LATERAL FLATTEN( INPUT => flatted_json_high_level:propertyManager:person:contactMethods )