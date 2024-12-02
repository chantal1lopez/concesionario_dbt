{{ config(
    materialized='view',
    schema='concesionario',
    database='ALUMNO24_DEV_GOLD_DB'
) }}

WITH mechanic_performance AS (
    SELECT
        mec.mechanic_id,
        mec.mechanic_name,
        COUNT(srv.service_id) AS total_services,
        SUM(srv.service_cost_usd) AS total_service_cost,
        AVG(srv.service_cost_usd) AS avg_service_cost
    FROM {{ ref('fact_services') }} srv
    LEFT JOIN {{ ref('dim_mechanics') }} mec
        ON srv.mechanic_id = mec.mechanic_id
    WHERE srv.is_active = TRUE
    GROUP BY
        mec.mechanic_id, mec.mechanic_name
)
SELECT * FROM mechanic_performance
