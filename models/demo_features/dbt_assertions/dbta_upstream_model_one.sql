
Select 
    'this is great!' as my_frist_column,
    7/1 as a_simple_calculation,
    current_timestamp() as current_time


UNION ALL 


Select 
    NULL as my_frist_column,
    1/1 as a_simple_calculation,
    current_timestamp() as current_time

UNION ALL 


Select 
    'wooHoo' as my_frist_column,
    3/1 as a_simple_calculation,
    current_timestamp() as current_time