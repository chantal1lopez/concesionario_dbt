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
    promotion_id,                        
    final_price_usd,                         
    base_price_usd,                      
    profit_margin,                          
    discount_value,                         
    financing_type            
FROM source         
