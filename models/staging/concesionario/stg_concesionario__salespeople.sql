WITH source AS (
        SELECT * FROM {{ source('concesionario', 'salespeople') }}
)

SELECT 
    salesperson_id,
    name,
    TRY_CAST(hire_date AS DATE) AS hire_date,
    branch_id,
    is_active,
    last_updated AS last_updated_utc
FROM source