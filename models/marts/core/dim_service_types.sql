WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__service_types') }}

)


SELECT *
FROM source
