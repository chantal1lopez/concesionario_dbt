{{ config(
    materialized='table',
    database='ALUMNO24_DEV_GOLD_DB',
    schema='concesionario'
) }}

WITH finance_metrics AS (
    SELECT
        DATE_TRUNC('month', s.sale_date) AS period,
        SUM(s.sale_price_usd) AS total_revenue,
        SUM(v.price_usd) AS total_cost,
        SUM(s.sale_price_usd - v.price_usd) AS total_margin,
        AVG(s.sale_price_usd - v.price_usd) AS avg_margin_per_sale
    FROM {{ ref('stg_concesionario__sales') }} s
    LEFT JOIN {{ ref('stg_concesionario__vehicles') }} v
        ON s.vehicle_id = v.vehicle_id
    WHERE s.is_active = TRUE
    GROUP BY DATE_TRUNC('month', s.sale_date)
)
SELECT * FROM finance_metrics
