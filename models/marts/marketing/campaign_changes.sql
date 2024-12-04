{{ config(
    materialized='view',
    schema='concesionario',
    database='ALUMNO24_DEV_GOLD_DB'
) }}

WITH snapshot_data AS (
    SELECT
        campaign_id,
        name AS snapshot_name,
        start_date AS snapshot_start_date,
        end_date AS snapshot_end_date,
        budget_usd AS snapshot_budget_usd,
        channel AS snapshot_channel,
        is_active AS snapshot_is_active,
        last_updated_utc AS snapshot_last_updated
    FROM {{ ref('campaigns_snapshot') }}
),

gold_data AS (
    SELECT
        campaign_id,
        name AS gold_name,
        start_date AS gold_start_date,
        end_date AS gold_end_date,
        budget_usd AS gold_budget_usd,
        channel AS gold_channel,
        is_active AS gold_is_active
    FROM {{ ref('dim_campaigns') }}
),

changes AS (
    SELECT
        gold.campaign_id,
        CURRENT_TIMESTAMP AS change_detected_at,
        CASE
            WHEN gold.gold_budget_usd != snap.snapshot_budget_usd THEN 'Budget Change'
            WHEN gold.gold_start_date != snap.snapshot_start_date OR gold.gold_end_date != snap.snapshot_end_date THEN 'Date Change'
            WHEN gold.gold_is_active != snap.snapshot_is_active THEN 'Status Change'
            ELSE 'Other Change'
        END AS change_type,
        snap.snapshot_budget_usd AS previous_budget,
        gold.gold_budget_usd AS current_budget,
        snap.snapshot_start_date AS previous_start_date,
        gold.gold_start_date AS current_start_date,
        snap.snapshot_end_date AS previous_end_date,
        gold.gold_end_date AS current_end_date,
        snap.snapshot_channel AS previous_channel,
        gold.gold_channel AS current_channel,
        snap.snapshot_is_active AS previous_is_active,
        gold.gold_is_active AS current_is_active
    FROM gold_data gold
    LEFT JOIN snapshot_data snap
        ON gold.campaign_id = snap.campaign_id
    WHERE 
        gold.gold_budget_usd != snap.snapshot_budget_usd
        OR gold.gold_start_date != snap.snapshot_start_date
        OR gold.gold_end_date != snap.snapshot_end_date
        OR gold.gold_is_active != snap.snapshot_is_active
)
SELECT * FROM changes
