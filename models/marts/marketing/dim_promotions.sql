{{ config(
    materialized='incremental',
    unique_key='promotion_id'  
) }}

WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__promotions') }}
)

SELECT *
FROM source
WHERE is_active = TRUE
{% if is_incremental() %}
  AND last_updated_utc > (
      SELECT MAX(last_updated_utc)
      FROM {{ this }}
  )
{% endif %}