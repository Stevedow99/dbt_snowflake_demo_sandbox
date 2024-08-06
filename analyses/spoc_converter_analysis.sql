{% set old_query %}
  select * from STEVE_D_SANDBOX.SPOC_CONVERTER_TESTING.FINAL_SALARIES
{% endset %}

{% set new_query %}
  select * from STEVE_D_SANDBOX.DBTSANDBOX_SDOWLING_SPOC_CONVERTER_TESTING.DEPARTMENTS_FINAL_SALARIES
{% endset %}

{{ audit_helper.compare_queries(
    a_query = old_query,
    b_query = new_query,
    primary_key = "SALARY_EMPLOYEE_ID"
) }}