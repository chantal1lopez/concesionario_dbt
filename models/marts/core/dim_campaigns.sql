WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__campaigns') }}

)


SELECT *
FROM source
