WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__salespeople') }}

)


SELECT *
FROM source
