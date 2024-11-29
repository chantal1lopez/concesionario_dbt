WITH source AS (
    SELECT * FROM {{ source('concesionario', 'vehicles') }}
)

SELECT
    vehicle_id,
    model,
    brand AS brand_name,
    type AS type_name,
    year,
    price AS price_usd,
    inventory_status,
    is_active,
    last_updated AS last_updated_utc
FROM source