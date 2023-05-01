{% macro force_error_macro(force_error=false) -%}

  
    {% if  force_error == true %}

            {% do 1/0 %}

    {% else %}

        {{log('================================================')}}
        {{log(' END MACRO ')}}
        {{log('================================================')}}

    {% endif %}


        


{%- endmacro %}