{% snapshot fact_sales_check_snp%}

{{
    config(
        strategy='check',
        unique_key='sale_id',
        check_cols=['sale_date', 'final_price_usd', 'discount_value', 'profit_margin'],
        target_schema='CONCESIONARIO_SNAPSHOTS',
        target_database='ALUMNO24_DEV_GOLD_DB'
    )
}}

SELECT *
FROM {{ ref('fact_sales') }}


{% endsnapshot %}