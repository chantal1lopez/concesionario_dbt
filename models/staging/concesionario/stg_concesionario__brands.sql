WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__vehicles') }}

)

SELECT 
    brand_id,
    brand_name
FROM source