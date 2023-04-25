{%- set some_value = get_high_watermark('model_mw_a', 'MODIFIED_TIMESTAMP') -%}


Select {{some_value}} as one_value,
'{{flags.WHICH}}' as two_value