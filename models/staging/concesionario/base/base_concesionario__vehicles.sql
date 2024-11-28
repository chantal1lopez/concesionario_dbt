WITH source AS (
    SELECT * FROM {{ source('concesionario', 'vehicles') }}
)

SELECT
    vehicle_id,
    model,
    brand AS brand_name,
    {{ dbt_utils.generate_surrogate_key(['brand']) }} AS brand_id,
    type AS type_name,
    {{ dbt_utils.generate_surrogate_key(['type']) }} AS type_id,
    year,
    price AS price_usd,
    inventory_status AS inventory_status_name,
    {{ dbt_utils.generate_surrogate_key(['inventory_status']) }} AS inventory_status_id,
    is_active,
    last_updated AS last_updated_utc
FROM source