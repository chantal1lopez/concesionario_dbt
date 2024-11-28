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
    {{ dbt_utils.generate_surrogate_key(['city','state']) }} AS address_id,
    {{ dbt_utils.generate_surrogate_key(['segment']) }} AS segment_id,
    segment,
    is_active,
    last_updated AS last_updated_utc
FROM source