{{
  config(
    materialized='incremental',
    transient=False,
    post_hook='{{ dbt_snowflake_demo_sandbox.upload_dbt_models() }}',
    unique_key='unique_id',
    on_schema_change='sync_all_columns',
    full_refresh=elementary.get_config_var('elementary_full_refresh'),
    tags="elementary_assets"
  )
}}

{{ elementary.get_dbt_models_empty_table_query() }}