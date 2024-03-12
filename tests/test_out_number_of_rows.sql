with source_data as (

    select
        count(*) as number_of_records
    from {{ source('school_data', 'school_districts') }}

)

select number_of_records
from source_data
where number_of_records > 0 