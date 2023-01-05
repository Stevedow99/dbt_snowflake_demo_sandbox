-- example of using the conditonal grant macro to grant different permissions depending on the target

{{ config(
    materialized = 'table', 
    post_hook = conditonal_grant(
                    { 'dev': { 'select': ['transformer', 'steve_d_demo_role'], 'insert': ['transformer', 'steve_d_demo_role'] }, 
                      'prod': { 'select': ['transformer', 'steve_d_demo_role']} 
                    })
) }}


Select 
    'this is great!' as my_frist_column,
    1/1 as a_simple_calculation,
    current_timestamp() as current_time