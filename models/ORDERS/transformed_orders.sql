{{ config(materialized='table', alias='orders_rpt') }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
)

SELECT
    order_id,
    customer_id,
    product_name,
    category,
    order_date,
    quantity,
    unit_price,
    total_amount,
    city,
    payment_mode,

    CASE
        WHEN total_amount >= 50000 THEN 'premium'
        WHEN total_amount >= 10000 THEN 'high'
        WHEN total_amount >= 3000  THEN 'medium'
        ELSE                            'low'
    END AS revenue_tier,

    CASE
        WHEN unit_price >= 30000 THEN 'luxury'
        WHEN unit_price >= 5000  THEN 'mid-range'
        ELSE                         'budget'
    END AS price_segment,

    CASE
        WHEN quantity >= 3 THEN 'bulk'
        WHEN quantity  = 2 THEN 'multi'
        ELSE                    'single'
    END AS order_size,

    CASE
        WHEN city IN ('Mumbai','Delhi')                            THEN 'Tier 1 Metro'
        WHEN city IN ('Bangalore','Chennai','Kolkata','Hyderabad') THEN 'Tier 1'
        WHEN city IN ('Pune','Ahmedabad','Jaipur')                 THEN 'Tier 2'
        ELSE                                                            'Tier 3'
    END AS city_tier,

    CASE
        WHEN payment_mode IN ('UPI','CARD') THEN 'Digital'
        ELSE                                     'Physical'
    END AS payment_type

FROM orders