with source as (
    select * from {{ source('snowflake_external_s3_stage', 'city_data') }}
),

renamed as (
    select
        value as id,
        c1 as LatD,
        c2 as LatM,
        c3 as LatS,
        c4 as NS,
        c5 as LonD,
        c6 as LonM,
        c7 as LonS,
        c8 as EW,
        c9 as City,
        c10 as State
    from source
)

select * from renamed;
