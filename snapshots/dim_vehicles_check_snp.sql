{% snapshot dim_vehicles_check_snp%}

{{
    config(
        strategy='check',
        unique_key='vehicle_id',
        check_cols=['model', 'brand', 'price_usd', 'inventory_status'],
        target_schema='CONCESIONARIO_SNAPSHOTS',
        target_database='ALUMNO24_DEV_GOLD_DB'
    )
}}

SELECT *
FROM {{ ref('dim_vehicle') }}

{% endsnapshot %}