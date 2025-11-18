CREATE TABLE orders_raw (
    order_id      INTEGER,
    customer_id   INTEGER,
    product_id    VARCHAR(50),
    amount        NUMERIC(10,2),
    created_at    TIMESTAMP,
    currency      VARCHAR(10)
);
