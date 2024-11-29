WITH source AS (
    SELECT * 
    FROM {{ ref('int_sales_sum') }}

)

-- Tabla de hechos: fact_services
SELECT
    sale_id,                                
    sale_date,                              
    customer_id,                           
    vehicle_id,                             
    branch_id,                              
    campaign_id,                            
    salesperson_id,                         
    sale_price_usd,                         
    vehicle_price_usd,                      
    profit_margin,                          
    discount_value,                         
    financing_type,                         
    total_sales_revenue_usd_by_branch,      
    total_sales_count_by_branch,            
    sales_count_by_financing_type,          
    sales_revenue_usd_by_campaign,          
    sales_count_by_salesperson,            
    sales_revenue_by_salesperson             
FROM source         
