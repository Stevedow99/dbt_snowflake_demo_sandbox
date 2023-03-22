# How data was loaded into snowflake


## Note: I did this in a somewhat manual way for the example but you can easily automate this


### Step One - Create a file format in snowflake
```sql

CREATE OR REPLACE FILE FORMAT SAMPLE_JSON_FORMAT
  TYPE = JSON;

```


### Step Two - Create a stage in snowflake
```sql

CREATE OR REPLACE TEMPORARY STAGE sample_json_data_stage FILE_FORMAT = SAMPLE_JSON_FORMAT;

```


### Step Three - PUT file in Snowflake Stage
```sql

PUT file://./sample_json.json @sample_json_data_stage AUTO_COMPRESS=TRUE;

```

### Step Four - Create Table in Snowflake 
#### Note if you were automating this you would want to us `COPY INTO`, since i'm just doing this example I don't need it

```sql

CREATE OR REPLACE TABLE SAMPLE_JSON_RAWEST_FORM_TABLE as (
    select 
        $1 as raw_json_data,
        current_timestamp as loaded_at_datetime
     FROM (SELECT * FROM @sample_json_data_stage (file_format => 'SAMPLE_JSON_FORMAT') t)
);

```

## Table is now loaded!
