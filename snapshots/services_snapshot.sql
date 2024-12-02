{% snapshot services_snapshot %}
{{ config(
    target_schema='snapshots',
    target_database='ALUMNO24_DEV_GOLD_DB',
    unique_key='service_id',
    strategy='timestamp',
    updated_at='last_updated_utc'
) }}

SELECT
    service_id,
    vehicle_id,
    service_date,
    service_type_id,
    cost_usd,
    mechanic_id,
    is_active,
    last_updated_utc
FROM {{ ref('stg_concesionario__services') }}

{% endsnapshot %}
