WITH source AS (
    SELECT * FROM {{ source('concesionario', 'services') }}
)

SELECT
    service_id,
    vehicle_id, 
    TRY_CAST(service_date AS DATE) AS service_date, 
    {{ dbt_utils.generate_surrogate_key(['service_type']) }} AS service_type_id,
    service_type,
    TRY_CAST(COST AS FLOAT) AS cost_usd, 
    {{ dbt_utils.generate_surrogate_key(['mechanic_name']) }} AS mechanic_id ,
    mechanic_name,
    is_active,
    last_updated AS last_updated_utc
FROM source