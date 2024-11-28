WITH source AS (
    SELECT * FROM {{ source('concesionario', 'campaigns') }}
)

SELECT
    campaign_id,
    name,
    TRY_CAST(start_date AS DATE) AS start_date,
    TRY_CAST(end_date AS DATE) AS end_date,
    TRY_CAST(budget AS FLOAT) AS budget_usd,
    channel as channel_name,
    {{ dbt_utils.generate_surrogate_key(['channel']) }} AS channel_id,
    is_active,
    last_updated AS last_updated_utc
FROM source