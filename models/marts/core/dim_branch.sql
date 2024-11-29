WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__branches') }}

)


SELECT *
FROM source
