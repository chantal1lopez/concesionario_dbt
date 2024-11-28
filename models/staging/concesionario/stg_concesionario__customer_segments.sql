WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__customers') }}

)

SELECT 
    segment_id,
    segment
FROM source