WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__vehicles') }}

)

SELECT 
    inventory_status_id,
    inventory_status_name
FROM source