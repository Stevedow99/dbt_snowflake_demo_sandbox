{% macro export_table_to_s3(stage, table_name, file_format_type='CSV', compression='NONE', field_enclosed_by='"', delimiter=',', max_file_size=104857600) %}

{% set query %}
COPY INTO @{{ stage }}/data_output_
  FROM {{ table_name }}
  FILE_FORMAT = (TYPE = '{{ file_format_type }}', COMPRESSION = '{{ compression }}', FIELD_OPTIONALLY_ENCLOSED_BY = '{{ field_enclosed_by }}', FIELD_DELIMITER = '{{ delimiter }}')
  MAX_FILE_SIZE = {{ max_file_size }};
{% endset %}

-- Execute the query in Snowflake
{{ log("Executing export to S3...", info=True) }}
{{ adapter.execute(query) }}
{{ log("Data export completed successfully.", info=True) }}

{% endmacro %}

