{# -------------------------------------------------------------------------------------------------------------------------- #}
{# -------------------------------------------------------------------------------------------------------------------------- #}
{# 
    Below is a list of three macros that all give the ability to apply grants based on different conditions 
     - These macros function very similar to the grants config in dbt except they are used in post-hooks since they
       are more complex

    1. The first macro "conditonal_grant" is the simplest form, this takes an input dict similar to the grants config
       and based on what the target will give different grants

#}
{# -------------------------------------------------------------------------------------------------------------------------- #}
{# -------------------------------------------------------------------------------------------------------------------------- #}

{# ########################################################################################################################## #}
{# conditonal_grant macro 

    Inputs
    ----------------
        target_grants_dictionary: a dictionary of the list of targets and the grants dictionary associated with that target
            example: 
             
                target_grants_dictionary = { 'dev': { 'select': ['bi_user'] }, 'prod': { 'select': ['bi_user', 'reporter'], 'insert': ['reporter'] } }

            example explained:
                if the target name is 'dev' then the grant of 'select' will be applied to the given model for the
                role 'bi_user'. If the target name is 'prod', then the grant of 'select' will be applied to the given model 
                for the role 'bi_user' and 'reporter' as well as give 'insert' privileges to the role 'reporter'


#}
{# ########################################################################################################################## #}
{# 
{% macro conditonal_grant(target_grants_dictionary) %}


{ 'dev': { 'select': ['bi_user'] }, 'prod': { 'select': ['bi_user', 'reporter'], 'insert': ['bi_user', 'reporter'] } }

{# if there is an execution of a run or build we run this post hook #

    {% if execute and flags.WHICH in ['run','build'] %}

    -- {# looping thru the dict to see if any of the targets match the set target name #
    {% for target_name in in target_grants_dictionary %}

        {# if the target name macthes the current target #
        {% if target_name == target.name %}

            {# set the target name privileges #
            {% set privilege_dict =  target_grants_dictionary[target_name] %}

            {# looping thru the dict to apply grants to each privilege type #
            {% for privilege_type in privilege_dict %}

                {# building the grant statement #
                {% set conditional_grant_statement = grant {{privilege_type}} to {{privilege_dict[privilege_type]}} -%}
                    grant {{privilege_type}} on {{ relation.type }} {{this}} to {{privilege_dict[privilege_type]}}
                {%- endcall-%}

#}
{#





            {% call statement('apply_conditional_grant', fetch_result=False) -%}
                select last_query_id() as last_query_id
            {%- endcall-%}  


        
        {% if test == 'yes' %}

            {%- set grant_role_name = 'TRANSFORMER' -%}

        {% else %}
            
            {%- set grant_role_name = 'STEVE_D_DEMO_ROLE' -%}
            
        {% endif %}

    {% endif %}

{% endmacro %}
#}