WITH cte_base_sales AS (
    -- Base de ventas con las uniones necesarias
    SELECT
        s.sale_id,
        s.sale_date,
        s.customer_id,
        s.vehicle_id,
        s.sale_price_usd,
        s.financing_type,
        s.salesperson_id,
        s.branch_id,
        s.campaign_id,
        v.price_usd AS vehicle_price_usd,
        p.discount_type AS promotion_type, -- Tipo de promoción
        p.discount_value AS promotion_discount_value -- Descuento aplicado
    FROM {{ ref('stg_concesionario__sales') }} s
    LEFT JOIN {{ ref('stg_concesionario__vehicles') }} v ON s.vehicle_id = v.vehicle_id
    LEFT JOIN {{ ref('stg_concesionario__promotions') }} p 
        ON s.campaign_id = p.campaign_id
        AND s.sale_date BETWEEN p.start_date AND p.end_date
),

cte_sales_metrics AS (
    -- Métricas calculadas para las ventas
    SELECT
        sale_id,
        sale_date,
        customer_id,
        vehicle_id,
        sale_price_usd,
        financing_type,
        promotion_type,
        salesperson_id,
        branch_id,
        campaign_id,
        vehicle_price_usd,
        -- Descuento aplicado
        CASE 
            WHEN vehicle_price_usd > sale_price_usd THEN vehicle_price_usd - sale_price_usd
            ELSE 0
        END AS discount_value,
        -- Margen de ganancia
        sale_price_usd - vehicle_price_usd AS profit_margin,
        -- Métrica acumulada: ingresos totales por sucursal
        SUM(sale_price_usd) OVER (PARTITION BY branch_id) AS total_sales_revenue_usd_by_branch,
        -- Cantidad total de ventas por sucursal
        COUNT(sale_id) OVER (PARTITION BY branch_id) AS total_sales_count_by_branch,
        -- Cantidad total de ventas por tipo de financiamiento
        COUNT(sale_id) OVER (PARTITION BY financing_type) AS sales_count_by_financing_type,
        -- Ingresos acumulados por campaña
        SUM(sale_price_usd) OVER (PARTITION BY campaign_id) AS sales_revenue_usd_by_campaign,
        -- Ventas por vendedor
        COUNT(sale_id) OVER (PARTITION BY salesperson_id) AS sales_count_by_salesperson,
        -- Ingresos por vendedor
        SUM(sale_price_usd) OVER (PARTITION BY salesperson_id) AS sales_revenue_by_salesperson
    FROM cte_base_sales
)

-- Selección final para la tabla intermedia
SELECT
    sale_id,
    sale_date,
    customer_id,
    vehicle_id,
    sale_price_usd,
    financing_type,
    salesperson_id,
    branch_id,
    campaign_id,
    vehicle_price_usd,
    promotion_type,
    discount_value,
    profit_margin,
    total_sales_revenue_usd_by_branch,
    total_sales_count_by_branch,
    sales_count_by_financing_type,
    sales_revenue_usd_by_campaign,
    sales_count_by_salesperson,
    sales_revenue_by_salesperson
FROM cte_sales_metrics
