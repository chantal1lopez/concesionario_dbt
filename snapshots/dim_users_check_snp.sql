{% snapshot dim_users_check_snp%}

{{
    config(
        strategy='check',
        unique_key='customer_id',
        check_cols=['name', 'email', 'phone', 'city', 'segment'],
        target_schema='CONCESIONARIO_SNAPSHOTS',
        target_database='ALUMNO24_DEV_GOLD_DB'
    )
}}

SELECT *
FROM {{ ref('dim_customers') }}

{% endsnapshot %}