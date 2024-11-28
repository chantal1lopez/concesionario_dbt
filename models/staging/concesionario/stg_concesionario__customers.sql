WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__customers') }}

)

SELECT 
    customer_id,
    name,
    email,
    phone,
    address_id,
    segment_id,
    is_active,
    last_updated_utc
FROM source