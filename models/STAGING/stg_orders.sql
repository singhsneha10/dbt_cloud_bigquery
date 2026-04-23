{{ config(materialized='view') }}

WITH source AS (
    SELECT * FROM {{ source('bigquery_source', 'orders') }}
)

SELECT
    order_id,
    customer_id,
    product_name,
    INITCAP(category)                    AS category,
    order_date,
    quantity,
    price                                AS unit_price,
    total_amount,
    INITCAP(city)                        AS city,
    UPPER(payment_mode)                  AS payment_mode
FROM source