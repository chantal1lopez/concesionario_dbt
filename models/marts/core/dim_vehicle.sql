WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__vehicles') }}

)


SELECT *
FROM source
