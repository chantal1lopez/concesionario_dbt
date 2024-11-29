WITH source AS (
    SELECT * FROM {{ source('concesionario', 'promotions') }}
)

SELECT
    promotion_id,
    name,
    TRY_CAST(start_date AS DATE) AS start_date,
    TRY_CAST(end_date AS DATE) AS end_date,
    discount_type,
    TRY_CAST(discount_value AS FLOAT) AS discount_value,
    campaign_id,
    is_active,
    last_updated AS last_updated_utc
FROM source