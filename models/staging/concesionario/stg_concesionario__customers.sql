WITH source AS (
    SELECT * FROM {{ source('concesionario', 'customers') }}
)

SELECT
    customer_id,
    name,
    email,
    phone,
    city,
    state,
    segment,
    is_active,
    last_updated AS last_updated_utc
FROM source