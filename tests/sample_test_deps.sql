{% if execute %}
  {% set quietly_ref_model_name = 'my_second_model' %}

  {% set models_returned = [] %}
  {% for node in graph.nodes.values()
     | selectattr("resource_type", "equalto", "model")
     | selectattr("name", "equalto", quietly_ref_model_name) %}
  
    {% do models_returned.append(node['database'] ~ "." ~ node['schema'] ~ "." ~ node['alias']) %}
  
  {% endfor %}

  {% set quiet_ref_model = models_returned[0]  %}

{% endif %}



select
    random_number
from {{ ref('my_first_model') }} mo
left join {{ quiet_ref_model }} mt
    on mo.my_frist_column = mt.my_frist_column
where random_number > 100000