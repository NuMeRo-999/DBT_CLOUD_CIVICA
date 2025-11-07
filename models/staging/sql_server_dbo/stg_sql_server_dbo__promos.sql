
WITH src_promos AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'promos') }}
),

renamed_casted AS (
    SELECT
        MD5(LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_'))) AS promo_id,
        LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_')) AS promo_name,
        discount AS dollars_discount,
        CASE 
            WHEN status = 'active' THEN TRUE
            ELSE FALSE
        END AS IsActive,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    FROM src_promos

    UNION ALL

    SELECT
    MD5('no_promo') AS promo_id,
    'no_promo' AS promo_name,
    0 AS dollars_discount,
    FALSE as status,
    CONVERT_TIMEZONE('UTC', current_date()) AS date_load
)

SELECT * FROM renamed_casted 