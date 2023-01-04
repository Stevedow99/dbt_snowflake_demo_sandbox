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

{%- macro conditonal_grant_testing(target_grants_dictionary) -%}

    {# if there is an execution of a run or build we run this post hook #}
    {%- if 2 > 1 -%}

    {# if there is an execution of a run or build we run this post hook. Instead of using a formal list we want this in string so we can use other post hooks if needed in our model  #}
    {%- set post_hook_list = [] -%}

        {# looping thru the dict to see if any of the targets match the set target name #}
        {%- for target_name in target_grants_dictionary -%}

            {# if the target name macthes the current target #}
            {%- if target_name == target.name -%}

                {# set the target name privileges #}
                {%- set privilege_dict =  target_grants_dictionary[target_name] -%}

                {# looping thru the dict to apply grants to each privilege type #}
                {%- for privilege_type in privilege_dict -%}

                    {# the list of users to grant #}
                    {%- set user_grant_list = privilege_dict[privilege_type] -%}

                    {# looping thru each user that needs to get grants #}
                    {%- for granted_user in user_grant_list -%}

                        {# building the grant statement #}
                        {%- set conditional_grant_statement = '"' ~ "grant " ~ privilege_type ~ " on " ~ this ~ " to " ~ granted_user ~ '"' -%}

                        {# adding the grant to the post hooks list #}
                        {%- do post_hook_list.append(conditional_grant_statement) -%}

                    {# end user_grant_list for loop #}
                    {%- endfor -%}
                
                {# end privilege_dict for loop #}
                {%- endfor -%}

            {# end target name if statement #}
            {%- endif -%}

        {# end target_grants_dictionary for loop #}
        {%- endfor -%}

    {# end if execute if statement #}
    {%- endif -%}

    {# formatting how the list should be returned #}
    {%- set post_hook_list_formatted =  post_hook_list | join(', ') -%}

    {# return the post hooks list #}
    {{post_hook_list_formatted}}

{%- endmacro -%}