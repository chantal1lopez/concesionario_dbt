{{ config(
    materialized='incremental',
    unique_key='branch_id'
) }}

WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__branches') }}
)
{% if is_incremental() %}
-- Obtener el valor máximo de last_updated_utc de la tabla incremental existente
SELECT *
FROM source
WHERE last_updated_utc > (
    SELECT MAX(last_updated_utc)
    FROM {{ this }}
)
{% endif %}
-- Primera carga: incluir todos los registros
SELECT *
FROM source
WHERE is_active = TRUE

