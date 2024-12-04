{{ config(
    materialized='incremental',
    unique_key='date_day'  
) }}

{% if is_incremental() %}
WITH new_dates AS (
    {{ dbt_date.get_date_dimension("2020-01-01", "2025-12-31") }}
),
max_existing_date AS (
    SELECT MAX(date_day) AS max_date
    FROM {{ this }}
)
SELECT *
FROM new_dates
WHERE date_day > (SELECT max_date FROM max_existing_date)
{% else %}
-- Primera carga completa
{{ dbt_date.get_date_dimension("2020-01-01", "2025-12-31") }}
{% endif %}
