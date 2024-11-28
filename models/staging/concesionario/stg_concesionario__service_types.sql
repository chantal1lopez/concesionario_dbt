WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__services') }}

)

SELECT 
    service_type_id,
    service_type
FROM source