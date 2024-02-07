{{
    config(
        pre_hook='CALL SYSTEM$WAIT(65)'
    )
}}

Select 
    'this is great!' as my_frist_column,
    1/1 as a_simple_calculation,
    current_timestamp() as current_time