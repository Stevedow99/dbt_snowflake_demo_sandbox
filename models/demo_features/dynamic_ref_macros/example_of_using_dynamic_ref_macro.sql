

{{ macro_with_ref_as_input( ref('small_model_one'), 'abc' ) }}

UNION ALL

{{ macro_with_ref_as_input( ref('small_model_two'), 'xyz' ) }}