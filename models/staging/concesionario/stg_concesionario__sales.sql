WITH source AS (
    SELECT * FROM {{ source('concesionario', 'sales') }}
)

SELECT
    sale_id,
    customer_id,
    vehicle_id,
    TRY_CAST(sale_date AS DATE) AS sale_date,
    TRY_CAST(sale_price AS FLOAT) AS sale_price_usd,
    financing_type,
    salesperson_id,
    branch_id,
    campaign_id,
    promotion_id,
    is_active,
    last_updated AS last_updated_utc
FROM source