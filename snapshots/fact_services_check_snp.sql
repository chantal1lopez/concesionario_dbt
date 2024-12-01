{% snapshot fact_services_check_snp%}

{{
    config(
        strategy='check',
        unique_key=['service_id', 'service_type_id'],
        check_cols=['service_date', 'service_cost_usd', 'total_service_cost_usd_per_vehicle', 'services_count_by_type'],
        target_schema='CONCESIONARIO_SNAPSHOTS',
        target_database='ALUMNO24_DEV_GOLD_DB'
    )
}}

SELECT *
FROM {{ ref('fact_services') }}

{% endsnapshot %}