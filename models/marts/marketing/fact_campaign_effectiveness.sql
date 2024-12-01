{{ config(
    materialized='table',
    database='ALUMNO24_DEV_GOLD_DB',
    schema='concesionario'
) }}

WITH campaign_metrics AS (
    SELECT
        c.campaign_id,
        c.name AS campaign_name,
        DATE_TRUNC('month', s.sale_date) AS sales_month,
        SUM(s.sale_price_usd) AS total_sales_revenue,
        COUNT(s.sale_id) AS total_sales_count,
        c.budget_usd AS campaign_budget,
        (SUM(s.sale_price_usd) - c.budget_usd) AS roi
    FROM {{ ref('stg_concesionario__sales') }} s
    LEFT JOIN {{ ref('stg_concesionario__campaigns') }} c
        ON s.campaign_id = c.campaign_id
    WHERE s.is_active = TRUE AND c.is_active = TRUE
    GROUP BY
        c.campaign_id,
        c.name,
        c.budget_usd,
        DATE_TRUNC('month', s.sale_date)
)
SELECT * FROM campaign_metrics
