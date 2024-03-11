
select
    random_number
from {{ ref('my_first_model') }} mo
left join {{ this.database }}.{{ this.schema }}.my_second_model mt
    on mo.my_frist_column = mt.my_frist_column
where random_number > 100000