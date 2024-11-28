WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__vehicles') }}

)

SELECT 
    vehicle_id,
    model,
    brand_id,
    type_id,
    year,
    price_usd,
    inventory_status_id,
    is_active,
    last_updated_utc
FROM source