SELECT
    product_id,
    INITCAP(product_name) AS product_name,
    INITCAP(category) AS category,
    CASE 
        WHEN active_flag = 'N' THEN 'Discontinued Product'
        ELSE INITCAP(product_name)
    END AS product_status
FROM products_raw;