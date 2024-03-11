{% macro add_row_to_example_schools_table() -%}



    {% set query %}
        INSERT INTO STEVE_D_RAW_DATA.SAMPLE_SCHOOL_DATA.school_districts (District_ID, District_Name, School_Name, file_name,  number_of_students, data_entry_confidence, school_achievement_rating, dbt_ready, file_processed, created_timestamp, modifed_timestamp)

        with random_numer as 

            (select uniform(1, 3, random()) as random_numer),

            school_data as (
            

            select
                case when (select random_numer from random_numer) = 1 then [101, 'North Valley', 'North Valley High', 'north_distict_data_'  ]
                when (select random_numer from random_numer) = 2 then [102, 'South Hill', 'South Hill Elementary', 'south_distict_data_'  ]
                when (select random_numer from random_numer) = 3 then [103, 'East Side', 'East Side Middle', 'east_distict_data_'  ] 
                END AS school_data
                
            ),

            final_table as (

                Select
                    school_data[0] as District_ID,
                    school_data[1] as District_Name,
                    school_data[2] as School_Name,
                    school_data[3] || '_' || uniform(1, 30000, random()) || '.csv' as file_name,
                    uniform(1, 4000, random()) as number_of_students,
                    uniform(1, 100, random()) as data_entry_confidence,
                    uniform(1, 10, random()) as school_achievement_rating,
                    TRUE as dbt_ready,
                    FALSE as file_processed,
                    CURRENT_TIMESTAMP() as created_timestamp,
                    CURRENT_TIMESTAMP() as modifed_timestamp
                from school_data)

            select * from final_table;
    {% endset %}

    {% do run_query(query) %}



{%- endmacro %}