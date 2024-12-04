WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__services') }}

)

SELECT 
    service_id,
    vehicle_id, 
    service_date, 
    service_type_id,
    cost_usd, 
    mechanic_id ,
    is_active,
    last_updated_utc
FROM source