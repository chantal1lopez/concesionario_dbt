WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__vehicles') }}

)

SELECT 
    type_id,
    type_name
FROM source