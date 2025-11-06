WITH source AS (

    SELECT * FROM {{ source('sql_server_dbo', 'orders') }}

),

renamed AS (

    SELECT
        order_id,
        shipping_service,
        shipping_cost AS dollars_shipping_cost,
        address_id,
        created_at,
        MD5(LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_'))) AS promo_id,
        estimated_delivery_at,
        order_cost AS dollars_order_cost,
        user_id,
        order_total AS dollars_order_total,
        CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
        tracking_id,
        status,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    FROM source

)

SELECT * FROM renamed

SELECT *
FROM {{ source('sql_server_dbo', 'orders') }}

WHERE estimated_delivery_at IS NULL

SELECT * FROM ORDERS_ITEMS

SELECT *, C.name
FROM {{ source('sql_server_dbo', 'orders') }} A
    LEFT JOIN {{ source('sql_server_dbo', 'order_items') }} B
        ON A.order_id = B.order_id
    LEFT JOIN {{ source('sql_server_dbo', 'products') }} C
        ON B.product_id = C.product_id

WHERE A.estimated_delivery_at IS NULL
