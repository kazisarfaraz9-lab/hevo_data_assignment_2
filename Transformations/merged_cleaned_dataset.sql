SELECT
    o.order_id,
    o.customer_id,
    COALESCE(c.email, 'Orphan Customer') AS customer_email,
    COALESCE(c.phone, 'Unknown') AS customer_phone,
    COALESCE(c.country_code, 'Unknown') AS customer_country,

    o.product_id,
    COALESCE(p.product_name, 'Unknown Product') AS product_name,
    COALESCE(p.category, 'Unknown') AS product_category,

    o.amount_fixed AS amount,
    o.currency,
    o.amount_usd,
    o.created_at
FROM orders_raw o
LEFT JOIN customers_raw c 
    ON o.customer_id = c.customer_id
LEFT JOIN products_raw p
    ON o.product_id = p.product_id