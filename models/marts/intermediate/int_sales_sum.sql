with
    cte_base_sales as (
        -- Base de ventas con las uniones necesarias
        select
            s.sale_id,
            s.sale_date,
            s.customer_id,
            s.vehicle_id,
            s.sale_price_usd,
            s.financing_type,
            s.salesperson_id,
            s.branch_id,
            s.campaign_id,
            s.promotion_id,
            v.price_usd as vehicle_price_usd,
            p.discount_type as promotion_type,  -- Tipo de promoción
            p.discount_value as promotion_discount_value  -- Descuento aplicado
        from {{ ref("stg_concesionario__sales") }} s
        left join
            {{ ref("stg_concesionario__vehicles") }} v on s.vehicle_id = v.vehicle_id
        left join
            {{ ref("stg_concesionario__promotions") }} p
            on s.promotion_id = p.promotion_id
            and s.sale_date between p.start_date and p.end_date
    ),

    cte_sales_metrics as (
        -- Métricas calculadas para las ventas
        select
            sale_id,
            sale_date,
            customer_id,
            vehicle_id,
            sale_price_usd as final_price_usd,
            vehicle_price_usd as base_price_usd,
            financing_type,
            promotion_type,
            salesperson_id,
            branch_id,
            campaign_id,
            promotion_id,
            -- Descuento aplicado
            case
                when vehicle_price_usd > sale_price_usd
                then vehicle_price_usd - sale_price_usd
                else 0
            end as discount_value,
            -- Margen de ganancia
            sale_price_usd - vehicle_price_usd as profit_margin

        from cte_base_sales
    )

-- Selección final para la tabla intermedia
select *
from
    cte_sales_metrics


