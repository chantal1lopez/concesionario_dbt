{% snapshot campaigns_snapshot %}
{{ config(
    target_schema='snapshots',
    target_database='ALUMNO24_DEV_GOLD_DB',
    unique_key='campaign_id',
    strategy='timestamp',
    updated_at='last_updated_utc'
) }}

SELECT
    campaign_id,
    name,
    start_date,
    end_date,
    budget_usd,
    channel,
    is_active,
    last_updated_utc
FROM {{ ref('stg_concesionario__campaigns') }}

{% endsnapshot %}
