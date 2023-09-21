-- {{ ref('samples_model_two') }}


-- picking up the data that got dropped via another airflow script
Select 
*
from {{target.database}}.CURATED.SAMPLE_WEATHER_DATA