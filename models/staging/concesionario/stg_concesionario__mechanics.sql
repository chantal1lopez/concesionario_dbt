WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__services') }}

)

SELECT 
    mechanic_id,
    mechanic_name,
    is_active,
    last_updated_utc
FROM source