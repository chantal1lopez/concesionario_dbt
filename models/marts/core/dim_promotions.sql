WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__promotions') }}

)


SELECT *
FROM source
