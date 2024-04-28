with source as (
    select * from {{ source('snowflake_external_s3_stage', 'city_data') }}
),

renamed as (
    select
        c1 as LatD,
        c2 as LatM,
        c3 as LatS,
        c4 as NS,
        c5 as LonD,
        c6 as LonM,
        c7 as LonS,
        REPLACE(c8, '"', '') AS EW,
        REPLACE(c9, '"', '') AS City,
        REPLACE(c10, '"', '') AS State
    from source
)

select * from renamed
