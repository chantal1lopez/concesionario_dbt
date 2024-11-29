WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__mechanics') }}

)


SELECT *
FROM source
