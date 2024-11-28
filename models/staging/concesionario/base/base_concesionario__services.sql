WITH source AS (
    SELECT * FROM {{ source('concesionario', 'services') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['service_id']) }} AS service_id,
    {{ dbt_utils.generate_surrogate_key(['vehicle_id']) }} AS vehicle_id, 
    TRY_CAST(service_date AS DATE) AS service_date, 
    {{ dbt_utils.generate_surrogate_key(['service_type']) }} AS service_type_id,
    TRY_CAST(COST AS FLOAT) AS cost, 
    {{ dbt_utils.generate_surrogate_key(['mechanic_name']) }} AS mechanic_id ,
    is_active,
    last_updated AS last_updated_utc
FROM source