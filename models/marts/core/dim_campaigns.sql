{{ config(
    materialized='incremental',
    unique_key='campaign_id' 
) }}

WITH source AS (
    SELECT * 
    FROM {{ ref('stg_concesionario__campaigns') }}
)

{% if is_incremental() %}
SELECT *
FROM source
WHERE last_updated_utc > (
    SELECT MAX(last_updated_utc)
    FROM {{ this }}
)
{% else %}
SELECT *
FROM source
{% endif %}
