# Snowflake Logging Macro Documentation:

### Objects that need to be set up to leverage this solution:

**On the dbt side:** 

1. Need to add the `snowflake_query_logging` macro into your `/macros` folder
    - This marco can be found [here on github](https://github.com/Stevedow99/dbt_snowflake_demo_sandbox/blob/main/macros/snowflake_utility_functions/logging/snowflake_logging.sql)
2. Need to add the `snowflake_query_logging` macro as a post hook to the model you would like to log
    - An example model with this post-hook can be found [here on github](https://github.com/Stevedow99/dbt_snowflake_demo_sandbox/blob/main/models/demo_features/snowflake_logging/snowflake_logging_example.sql)
        - note: when you configure the macro in a post hook, the input parameter is `this` - `this` refers to the model that is running the macro. More info on the `this` command can be found [here](https://docs.getdbt.com/reference/dbt-jinja-functions/this).


### Video demo on using the macro
[Demo Video](https://www.loom.com/share/a3938814f6c448b7a903b42f2ab64bd3)
    

### What does the macro do?:

- When this macro is added as a post-hook on a given model or models, every time that model is included in a `dbt run` or `dbt build` it will log the following information about the model in a table named `DBT_LOG_TABLE`
    - Information logged in the `DBT_LOG_TABLE` in Snowflake:
        - dbt model name
        - dbt model snowflake location
        - Snowflake Query ID
        - Query Text (The command that was passed down in the query)
        - Database name
        - Schema name
        - Query type
        - Username or service account that ran the query
        - Role name that ran the query
        - Warehouse that ran the query
        - Size of the warehouse that ran the query
        - Execution status of the query
        - Error code (If a failure happened)
        - Error message (If a failure happened)
        - Number of bytes scanned
        - Rows produced by the query
        - Start time of execution
        - End time of execution
        - Total elapsed time of execution
        

### Example:

- If i???m looking to log the model `monthly_gross_revenue` , I will need to add the `snowflake_query_logging` macro as a `post_hook` in my model config. My model file will look like this:
    
    ```yaml
    {{
        config(
            materialized='table',
            post_hook = [
                "{{snowflake_query_logging(this)}}"
            ]
        )
    }}
    
    select
        date_trunc(month, order_date) as order_month,
        sum(gross_item_sales_amount) as gross_revenue
    
    from {{ ref('fct_order_items') }}
        group by 
            order_month
        order by 
            order_month
    ```
    
- When I execute a `dbt run` or `dbt build` command that includes this model, information on the model will get logged to a table named `DBT_LOG_TABLE` in Snowflake. This table will live in the default database you are using, the schema it will use is your default schema for your environment + `_audit` .
    - For example if I am working with the following inputs
        - Database on my dbt environment: `SANDBOX`
        - Default schema on my dbt environment: `dbt_sdowling`
    - The audit table would then get created in Snowflake here:
        - `SANDBOX.DBT_SDOWLING_AUDIT.DBT_LOG_TABLE`
- Each time the model gets run, a new record gets logged in Snowflake
