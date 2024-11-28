WITH source AS (
    SELECT * FROM {{ source('concesionario', 'branches') }}
)

SELECT
    branch_id,
    branch_name,
    city,
    state,
    {{ dbt_utils.generate_surrogate_key(['city','state']) }} AS address_id,
    TRY_CAST(opened_date AS DATE) AS opened_date,
    is_active,
    last_updated AS last_updated_utc
FROM source