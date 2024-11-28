WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__campaigns') }}

)

SELECT 
    channel_id,
    channel_name
FROM source