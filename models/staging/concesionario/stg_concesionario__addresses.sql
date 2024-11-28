WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__customers') }}

)

SELECT 
    address_id,
    city,
    state
FROM source