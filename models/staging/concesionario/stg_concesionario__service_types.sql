WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__services') }}

)

SELECT 
    DISTINCT  service_type_id,
    service_type as service_type_name
FROM source