WITH source AS (
    SELECT * 
    FROM {{ ref('base_concesionario__campaigns') }}

)

SELECT 
    campaign_id,
    name,
    start_date,
    end_date,
    budget_usd,
    channel_id,
    is_active,
    last_updated_utc
FROM source