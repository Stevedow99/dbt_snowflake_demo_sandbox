-- using the conditonal grant macro along with other post hooks

{% set post_hooks =  conditonal_grant(
                    { 'default': { 'select': ['transformer', 'steve_d_demo_role'], 'insert': ['transformer', 'steve_d_demo_role'] }, 
                      'prod': { 'select': ['transformer', 'steve_d_demo_role']} 
                    })
                    %}

{%- do post_hooks.append("select 1 as one") -%}


{{ config(
    materialized = 'table', 
    post_hook = post_hooks
    ) }}




Select 
    'this is great!' as my_frist_column,
    1/1 as a_simple_calculation,
    current_timestamp() as current_time