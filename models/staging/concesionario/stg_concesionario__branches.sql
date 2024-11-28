WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__branches') }}

)

SELECT 
    branch_id,
    branch_name,
    address_id,
    opened_date,
    is_active,
    last_updated_utc
FROM source